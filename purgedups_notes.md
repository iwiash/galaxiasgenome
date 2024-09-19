purgedups
```
module load purge_dups
```
step 1:
```
pd_config.py -n (output name)(.json?) (ref file in fasta/fasta.gz format) (text doc with list of pacbio file abolute paths 1 per line)

(for the text doc) realpath (pacbio filename)  <- gives the absol path for the file  then nano into doc (maybe need to be called pb.fofn but prob can be anything)
```
produces a config file in json format which has the mem needed for all the stuff its gonna do? - look and see if it is small enough to run in jupyter - prob will be
step 2 is to edit this if needed.

step 3
```
run_purge_dups.py (config file) src (species identifier - made up, i guess just Gbrev or smt)
```
(for src) might need to tell it where to find the run command? or might not - check if it can find run_purge_dups and if it cant then:
```
which purge_dups <- tells you where it is, copy absol path and put in 'src
```
code that didnt work
```
run_purge_dups.py config_gbrev.json /opt/nesi/CS400_centos7_bdw/purge_dups/1.2.6-gimkl-2022a-Python-3.10.5/bin/purge_dups gBrev1
```
