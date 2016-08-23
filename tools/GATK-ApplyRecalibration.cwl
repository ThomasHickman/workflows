#!/usr/bin/env cwl-runner

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  doap: http://usefulinc.com/ns/doap#
  adms: http://www.w3.org/ns/adms#
  dcat: http://www.w3.org/ns/dcat#

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- http://usefulinc.com/ns/doap#
- http://www.w3.org/ns/adms#
- http://www.w3.org/ns/dcat.rdf

cwlVersion: v1.0
class: CommandLineTool

adms:includedAsset:
  doap:name: GATK
  doap:description: 'The Genome Analysis Toolkit or GATK is a software package for
    analysis of high-throughput sequencing data, developed by the Data Science and
    Data Engineering group at the Broad Institute.  The toolkit offers a wide variety
    of tools, with a primary focus on variant discovery and genotyping as well as
    strong emphasis on data quality assurance. Its robust architecture, powerful processing
    engine and high-performance computing features make it capable of taking on projects
    of any size.

    VQSR
    Note that HaplotypeScore is no longer applicable to indels
    see http://gatkforums.broadinstitute.org/discussion/2463/unified-genotyper-no-haplotype-score-annotated-for-indels

    '

doc: |
      GATK-VariantsRecalibrator.cwl is developed for CWL consortium
      Check gatk forum: http://gatkforums.broadinstitute.org/discussion/1259/what-vqsr-training-sets-arguments-should-i-use-for-my-specific-project

      Usage:
      ```
      java -Djava.io.tmpdir=$tmpDir -Xmx8G \
            -jar [gatk.jar] \
            -T ApplyRecalibration \
            -R [reference_fasta] \
            -recalFile    $tmpDir/out.recal \
            -tranchesFile $tmpDir/out.tranches \
            -o            $tmpDir/out.vcf \
            --ts_filter_level 99.9 \
            -mode [glm] \
            -nt 4
      ```

  doap:homepage: "https://www.broadinstitute.org/gatk/"
  doap:repository:
  - class: doap:GitRepository
    doap:location: "https://github.com/broadgsa/gatk.git"
  doap:release:
  - class: doap:Version
    doap:revision: '3.4'
  doap:license: mixed licensing model
  doap:category: commandline tool
  doap:programming-language: JAVA
  doap:developer:
  - class: foaf:Organization
    foaf:name: Broad Institute
doap:name: GATK-ApplyRecalibration.cwl

dct:creator:
- class: foaf:Organization
  foaf:name: H3AbioNet
  foaf:url: http://h3abionet.org/
  foaf:member:
  - class: foaf:Person
    id: yassine.souilmi@fulbrightmail.org
    foaf:name: Yassine Souilmi
    foaf:mbox: mailto:yassine.souilmi@fulbrightmail.org

doap:maintainer:
- class: foaf:Organization
  foaf:name: H3AbioNet
  foaf:url: http://h3abionet.org/
  foaf:member:
  - class: foaf:Person
    id: yassine.souilmi@fulbrightmail.org
    foaf:name: Yassine Souilmi
    foaf:mbox: mailto:yassine.souilmi@fulbrightmail.org

hints:
- $import: envvar-global.yml
- $import: GATK-docker.yml

inputs:
  multithreading_nt:
    type: int
    default: 4
    inputBinding:
      position: 12
      prefix: --nt
    doc: multithreading option

  reference:
    type: File
    inputBinding:
      position: 6
      prefix: -R
    doc: reference genome

  recal_file:
    type: file
    inputBinding:
      position: 7
      prefix: -recalFile
    doc: the recal file generated by VariantRecalibrator

  tranches_file:
    type: file
    inputBinding:
      position: 8
      prefix: -tranchesFile
    doc: the tranches file generated by VariantRecalibrator

  mode:
    type: string
    inputBinding:
      position: 11
      prefix: -mode
    doc: specify if VQSR is called on SNPs or Indels

  ts_filter_level:
    type: float
    default: 99.9
    inputBinding:
      position: 10
      prefix: --ts_filter_level
    doc: filtering level default value is 99.9



  java_arg:
    type: string
    default: -Xmx8g
    inputBinding:
      position: 1

    type: string
    default: -Djava.io.tmpdir=/tmp
      position: 2

  out:
    type: File?
    inputBinding:
      position: 9
      prefix: -o
    doc: The output recalibration VCF file to create


arguments:
- valueFrom: ./test/test-files
  position: 2
  separate: false
  prefix: -Djava.io.tmpdir=
- valueFrom: /usr/local/bin/GenomeAnalysisTK.jar
  position: 3
  prefix: -jar
- valueFrom: ApplyRecalibration
  position: 4
  prefix: -T
baseCommand: [java]
