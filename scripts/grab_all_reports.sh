#!/usr/bin/env bash

# cp all the report related infor into a second sub directory for easier transfor to laptop

basedir=${1}

cd ${basedir}
reports=`find . -name sub*.html | grep -v reportlets`

for report in ${reports}; do
  report_dir=$(dirname ${report})
  reportbase=$(basename -- "${report}")
  subject="${reportbase%%.*}"
  mkdir -p reports/${report_dir}/${subject}
  cp ${report} reports/${report_dir}/
  cp -r ${report_dir}/${subject}/figures reports/${report_dir}/${subject}/
done
  
