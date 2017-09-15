#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
nodedir=$DIR/node

if [ -d "$nodedir" ]; then
  (cd $nodedir                 \
    && git reset master --hard \
    && git clean -f -d         \
    && git checkout master     \
  )
else
  git clone git@github.com:nodejs/node.git $nodedir
fi

versions=('v8.x')

for (( i=0; i<${#versions[@]}; i=$i+1 ));
do
  node_version="${versions[$i]}"

  # only update versions we haven't documented yet
  if [ ! -d "$DIR/node-$node_version" ]; then
    (cd $nodedir
      git reset master --hard
      git clean -f -d

      git checkout origin/$node_version                                                                                            \
        && cat "$DIR/template.doxygen" | sed "s.__root__.$DIR.g; s/__node_version__/$node_version/g;" > "$DIR/node.doxygen" \
        && doxygen "$DIR/node.doxygen")
  fi
done
