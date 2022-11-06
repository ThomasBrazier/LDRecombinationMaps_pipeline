# A Snakemake pipeline to estimate LD-based recombination maps


This pipeline is a BETA version in active development (use the `main` branch). It is fully functional but not error-prone and not optimized (e.g. better use of parallelism). Please report bugs and errors for improvement.


## Installation

### Dependencies

Strict dependencies must be installed before first run:
- conda
- snakemake
- singularity (> 3.0)

After installing dependencies, clone the github directory where you want to perform computations. The github directory will be your working directory.

```
git clone https://github.com/ThomasBrazier/LDRecombinationMaps-pipeline.git 
```

In addition, Singularity images are required for additional softwares. Run within the working directory:

```
singularity pull faststructure.sif docker://tombrazier/faststructure
singularity pull ldhat.sif docker://tombrazier/ldhat
```

To install conda environments at the first run of the pipeline, use

```
snakemake -s data_preprocessing.snake --use-conda --conda-create-envs-only
snakemake --use-conda --conda-create-envs-only
```

Pre-generated look-up tables are necessary for LDhat. Make sure to download them in the working directory.

```
wget https://github.com/auton1/LDhat/tree/master/lk_files
```


## Usage

Put your `<dataset>` directory into `./data`.
By default, working directory is `data/`. To run in a different directory, change the value in `config.yaml` or in command line.

You can configure your pipeline in the `config.yaml` file that you must copy into the <dataset> directory.

You need a first step of data preprocessing to infer the number of independent genetic populations in the sample (based on FastStructure [[1]](#1)) and output summary statistics to choose the most appropriate population in further analyses. It produces a file `structure/poplist.*.*` which contains the list of individuals to sample in the main pipeline.
Once population structure is inferred from 'popstatistics.<K>', 'structure/chooseK' and 'structure/distruct.<K>.svg', run the main pipeline after specifying the chosen <K> number of genetic clusters to consider and the <population> to sample in your config.yaml.

```
ncores=<number of cores to use>
snakemake -s data_preprocessing.snake --use-conda --use-singularity --cores $ncores -j $ncores --config dataset=<dataset> chromosome=<chromosome>
```

After running the preprocessing step, run directly the main pipeline for a <dataset> and a single <chromosome> (don't forget to configure the `config.yaml` with your desired population).

```
snakemake -s Snakefile --use-conda --use-singularity --cores $ncores --config dataset=<dataset> --K <K> --pop <pop> --chrom <chromosome>
```

Alternatively, you can use the Singularity launcher script and modify it for your custom needs.

```
bash.sh <dataset> <chromosome>
# or
singularity bash.sh <dataset> <chromosome>
```

At the current stage, you can run as many <dataset> as you want in parallel, as directories are isolated, but only one <chromosome> at a time to avoid interferences beween Snakemake parallel processes accessing the same files. This issue is on a list of future improvements.
Only one population can be sampled in a sample directory. For analysing more than one population, duplicate the sample directory.


## Details of the main pipeline


### ShapeIt

After subsampling the population, the genotypes are phased with ShapeIt2 [[2]](#2). 

Verify that contig length are annotated in the vcf file header as they are necessary at the phasing step.

### Pseudodiploids


### LDhat

Recombination rates are estimated with `LDhat` [[3]](#3).

Theta must be specified in the `config.yaml` file. The look-up table will be computed from a pre-generated one with the `lkgen` function of LDhat. A maximum of 100 haploid individuals is allowed (50 diploids). If you specify a `theta` different of 0.01 or 0.001, a complete look-up table will be computed, which require extra time. 


### The Large sample sub-pipeline for large numbers of SNPs




## Input Files

* <dataset>.vcf.gz, a tabix vcf file, bgzipped
* samplelist, a one column text file with a list of individuals to keep in the original vcf


## Output Files



## Options





## References

<a id="1">[1]</a> 
Raj, A., Stephens, M., & Pritchard, J. K. (2014).
fastSTRUCTURE: variational inference of population structure in large SNP data sets.
Genetics, 197(2), 573-589.

<a id="2">[2]</a>
Delaneau, O., Zagury, J. F., & Marchini, J. (2013).
Improved whole-chromosome phasing for disease and population genetic studies.
Nature methods, 10(1), 5-6.

<a id="3">[3]</a>
Auton, A., Myers, S., & McVean, G. (2014).
Identifying recombination hotspots using population genetic data.
arXiv preprint arXiv:1403.4264.

