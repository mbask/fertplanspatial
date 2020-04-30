
if ( requireNamespace("tinytest", quietly=TRUE) ){
  home <- identical(Sys.info()[["nodename"]], "manjdell")
  tinytest::test_package("fertplanspatial", at_home = home)
}

