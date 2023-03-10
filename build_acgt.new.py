#!/bin/env python

from argparse import ArgumentParser
from os import path
import os
import sys
import yaml
import re
import string

from os import path
import textwrap
import numpy as np

from multiprocessing import Pool

_strtmpl = """\
    <?xml version="1.0" encoding="UTF-8" ?>
    <root>
    <group name="" type="seq_access">
      <variable key="$$FILE_PATH" value="." type="string" />
      <file name="compact_dna" fullpath="./compact_dna_${chrom_name}" filetype="uint64arr" />
      <variable key="description" value="4-bit code" type="string" />
      <variable key="dna_length" value="${chrom_size}" type="uint64" />
      <variable key="sequence_name" value="${chrom_name}" type="string" />
      <variable key="version" value="1.0" type="string" />
    </group>
    </root>
    """
_tmpl = string.Template(textwrap.dedent(_strtmpl))
def _write_xml(assembly_name, chrom_name, chrom_size, outdir):
    ofname = assembly_name + '.' + chrom_name + '.xml'
    with open(path.join(outdir, ofname), 'w') as fo:
        fo.write(_tmpl.substitute(chrom_name=chrom_name, chrom_size=chrom_size))
    return ofname

_CHARS = ('A', 'C', 'G', 'T', 'a', 'c', 'g', 't', 'N')
_CMAP = dict((_CHARS[i],i) for i in range(len(_CHARS)))
def _build_compact(inp_fa_file, chrom_size, out_compact_file):
    f = open(inp_fa_file, 'r')
    header_line = next(f).lstrip()
    assert (header_line.startswith('>')), "expected '>' in FASTA file" 
    h = np.memmap(out_compact_file, dtype='uint8', mode='w+', shape=(chrom_size + 1)/2)
    carry = ''
    p = 0
    # path.join(odir, 'compact_dna_' + chrom_name)
    for line in f:
        line = line.rstrip()
        chrom_size -= len(line)
        oink = carry + re.sub(r'[^ACGTacgt]', 'N', line)
        if (len(oink) % 2 == 1):
            carry = oink[-1]
            oink = oink[0:-1]
        i = 0
        while i < len(oink):
            idx0 = _CMAP[oink[i]]
            idx1 = _CMAP[oink[i+1]]
            v = (idx1 << 4) | (idx0)
            h[p] = v
            i += 2
            p += 1
    if len(carry) > 0:
        assert(len(carry) == 1)
        idx0 = _CMAP[carry[0]]
        h[p] = idx0
    assert (chrom_size == 0), "declared sequence length, and real sequence length mismatched"


def seq_build(assembly_name, chrom_name, chrom_size, fa_seq_file, outdir):
    metafile = _write_xml(assembly_name, chrom_name, chrom_size, outdir)
    compactfile = path.join(outdir, 'compact_dna_' + chrom_name)
    _build_compact(fa_seq_file, chrom_size, compactfile)
    return metafile
    
def make_it_so(name, chrom, size, inpdir, outdir):
    fafile = path.join(inpdir, chrom + '.fa')
    if not path.exists(fafile):
        print >> sys.stderr, "Warning: Cannot find FA file for chromosome: " + chrom + " (assembly: " + name + ')'
        return None,None
    try:
        outfile = seq_build(name, chrom, size, fafile, outdir)
        print 'OK: %s'% chrom
        return chrom, outfile
    except:
        print >> sys.stderr, 'Failed: %s'% chrom
        raise

def helper(args):
    func = args[0]
    return func(*args[1:])

def main(args):
    # read chromosome sizes
    chrsize = {}
    with open(args.chromfile) as f:
        for line in f:
            p, q = line.strip().split('\t')
            chrsize[p] = int(q)
    
    if not path.exists(args.outdir):
        os.mkdir(args.outdir)
    
    acgtdict = {}
    if (args.proc == 1):
        for chrom, size in chrsize.iteritems():
            k, v = make_it_so(args.libname, chrom, size, args.inpdir, args.outdir)
            if (k): acgtdict[k] = v
    else:
        plist = []
        for chrom, size in chrsize.iteritems():
            plist.append((make_it_so, args.libname, chrom, size, args.inpdir, args.outdir))
        pool = Pool(args.proc)
        results = pool.map(helper, plist)
        for k,v in results:
            if (k): acgtdict[k] = v
    
    # create main file
    outfile = path.join(args.outdir, "%s.acgt"% args.libname)
    with open(outfile, "w") as out:
        acgtdict["__lib__"] = args.libname
        acgtdict["__sizes__"] = chrsize
        out.write(yaml.dump(acgtdict))

if __name__ == '__main__':
    parser = ArgumentParser(usage='This script expects to find file with pattern <chrom.fa> in input directory')
    parser.add_argument("libname", help="Library name")
    parser.add_argument("chromfile", help="File containing info on chromosome length")
    parser.add_argument("-i", "--inpdir", help="Input directory", default=".")
    parser.add_argument("-o", "--outdir", help="Output directory", default=".")
    parser.add_argument('-p', '--proc', type=int, help='Number of processors to use (default=auto)', default=4)
    args = parser.parse_args()
    sys.exit(main(args))
    
