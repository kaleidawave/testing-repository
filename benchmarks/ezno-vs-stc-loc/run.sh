echo "::group::Install LOC"
cargo install loc
echo "::endgroup::"

echo "::group::Get STC"
git clone https://github.com/dudykr/stc stc
echo "::endgroup::"

echo "::group::Get EZNO"
gh auth status
gh repo clone kaleidawave/ezno-private ezno
gh repo clone kaleidawave/derive-finite-automaton temp
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
loc ezno/checker
cat ezno/README.md
echo "::endgroup::"