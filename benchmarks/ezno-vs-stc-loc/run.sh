echo "::group::Install LOC"
cargo install loc
echo "::endgroup::"

echo "::group::Get STC"
git clone https://github.com/dudykr/stc stc
echo "::endgroup::"

echo "::group::Get EZNO"
gh repo clone kaleidawave/ezno-private ezno
echo "::endgroup::"

echo "::group::Check both projects there"
ls
echo "::endgroup::"

echo "::group::STC information"
loc stc
cat stc/README.md
echo "::endgroup::"

echo "::group::EZNO information"
loc ezno
cat ezno/README.md
echo "::endgroup::"