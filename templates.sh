#!/bin/bash

set -euo pipefail

function download_file() {
  # $1 is URL, $2 is output file name
  # TODO: Check whether curl exists
  curl -o "$2" -L "$1"
}

TMP=$(mktemp -d)

function get_acm() {
  # ACM Templates
  # https://www.acm.org/publications/proceedings-template
  ACM_URL="https://www.acm.org/binaries/content/assets/publications/consolidated-tex-template/acmart-primary.zip"
  ACM_FILES=(acmart-primary/acmart.cls acmart-primary/ACM-Reference-Format.bst)
  download_file "$ACM_URL" "$TMP/acm.zip"
  unzip -j "$TMP/acm.zip" "${ACM_FILES[@]}"
}

function get_lncs() {
  # Springer LNCS
  # https://www.springer.com/gp/computer-science/lncs/conference-proceedings-guidelines
  LNCS_URL="https://resource-cms.springernature.com/springer-cms/rest/v1/content/19238648/data/v1"
  LNCS_FILES=(llncs.cls splncs04.bst)
  download_file "$LNCS_URL" "$TMP/lncs.zip"
  unzip -j "$TMP/lncs.zip" "${LNCS_FILES[@]}"
}

function get_lipics() {
  # Dagstuhl LIPIcs
  # https://submission.dagstuhl.de/documentation/authors
  LIPICS_URL="https://submission.dagstuhl.de/styles/download-tag/lipics/v2021.1.2/authors/zip"
  LIPICS_FILES=("lipics-v2021.cls")
  download_file "$LIPICS_URL" "$TMP/lipics.zip"
  unzip -j "$TMP/lipics" "${LIPICS_FILES[@]}"
}

function get_lmcs() {
  # Logical methods in computer science
  # https://lmcs.episciences.org/page/authors-latex-style
  LMCS_URL="https://lmcs.episciences.org/public/lmcs.cls"
  download_file "$LMCS_URL" ./lmcs.cls
}

case "$1" in
  "acm"|"sigplan")
    get_acm
    ;;
  "lncs"|"springer")
    get_lncs
    ;;
  "lipics"|"dagstuhl")
    get_lipics
    ;;
  "lmcs")
    get_lmcs
    ;;
  "all")
    get_acm
    get_lncs
    get_lipics
    get_lmcs
    ;;
  *)
    echo "Unrecognised option"
    echo "Supported options are acm, lncs, lipics, lmcs, and all"
    ;;
esac
