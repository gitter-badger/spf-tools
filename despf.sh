#!/bin/sh -e
#
# Usage: ./despf <domain_with_SPF_TXT_record>

# Check for required tools
for cmd in drill awk grep sed cut
do
  type $cmd >/dev/null
done

a="/$0"; a=${a%/*}; a=${a#/}; a=${a:-.}; BINDIR=$(cd $a; pwd)
export PATH=$BINDIR/include:$PATH
. global.inc.sh
. despf.inc.sh

# Read DNS_TIMEOUT if spf-toolsrc is present
test -r $SPFTRC && . $SPFTRC

loopfile=$(mktemp /tmp/despf-loop-XXXXXXX)
echo random-non-match-tdaoeinthaonetuhanotehu > $loopfile
trap "cleanup $loopfile; exit 1;" INT QUIT

domain=${1:-'orig.spf-tools.ml'}

despfit $domain $loopfile | grep . || { cleanup $loopfile; exit 1; }
cleanup $loopfile
