{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, python
, fonttools, defcon, lxml, fs, unicodedata2, zopfli, brotlipy, fontpens
, brotli, fontmath, mutatormath, booleanoperations
, ufoprocessor, ufonormalizer, psautohint, tqdm
, setuptools_scm
, pytest
}:

buildPythonPackage rec {
  pname = "afdko";
  version = "3.5.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qg7dgl81yq0sp50pkhgvmf8az1svx20zmpkfa68ka9d0ssh1wjw";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [
    booleanoperations
    fonttools
    lxml           # fonttools[lxml], defcon[lxml] extra
    fs             # fonttools[ufo] extra
    unicodedata2   # fonttools[unicode] extra
    brotlipy       # fonttools[woff] extra
    zopfli         # fonttools[woff] extra
    fontpens
    brotli
    defcon
    fontmath
    mutatormath
    ufoprocessor
    ufonormalizer
    psautohint
    tqdm
  ];

  # tests are broken on non x86_64
  # https://github.com/adobe-type-tools/afdko/issues/1163
  # https://github.com/adobe-type-tools/afdko/issues/1216
  doCheck = stdenv.isx86_64;
  checkInputs = [ pytest ];
  checkPhase = ''
    PATH="$PATH:$out/bin" py.test
  '';

  meta = with stdenv.lib; {
    description = "Adobe Font Development Kit for OpenType";
    homepage = "https://adobe-type-tools.github.io/afdko/";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
