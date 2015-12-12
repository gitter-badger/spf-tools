#!/bin/sh
#
# Usage: ./compare.sh [domain [compare_domain]]

domain=${1:-'spf-tools.ml'}
compare_domain=${2:-'orig.spf-tools.ml'}

a="/$0"; a=${a%/*}; a=${a#/}; a=${a:-.}; BINDIR=$(cd $a; pwd)
PATH=$BINDIR:$PATH

temp=$(mktemp /tmp/$$.XXXXXXXX)

despf.sh $domain | normalize.sh | simplify.sh > ${temp}-1 2>/dev/null
despf.sh $compare_domain | normalize.sh | simplify.sh > ${temp}-2 2>/dev/null

trap "rm ${temp}-*" EXIT
diff ${temp}-1 ${temp}-2
cmp ${temp}-* 2>/dev/null 1>&2 && echo "Everything OK" || {
  echo "Please update SPF TXT records of $domain!" 1>&2
  exit 1
}
