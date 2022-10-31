cargo install loc

git clone https://github.com/dudykr/stc stc

echo $SPECIAL_GH_TOKEN > gh auth login --with-token 
gh repo clone kaleidawave/ezno-private ezno

ls

loc stc
cat stc/README.md

loc ezno
cat ezno/README.md