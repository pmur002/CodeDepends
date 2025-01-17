test_exprblock = function()
  {

    scr = readScript("testcode/inputtest1.R")
    res = getInputs(scr)[[1]]
    checkTrue(all(res@inputs == c("n", "c", "titletxt")), "Failed to exclude symbols from input list that are ouputs from previous line in expression block")
    checkTrue(all(res@outputs == c("a", "b")))
  }

#this one (formulas) will be hard to pass, but is probably important if we want
#to use CodeDepends on analysis code people are actually using
#It may be impossible to catch this 100% of the time, eg when analyst uses a
#positional matching to specify the data argument, but we should probably catch
#it when they do data=... (or potentially even dat=...)
test_formula = function()
  {
    scr = readScript("testcode/inputtest2.R")
    res = getInputs(scr)[[2]] #fit = lm(b~a, data=df)
    checkTrue(all(res@inputs == "df"), "Test for understanding that formula elements don't indicate additional inputs when data argument is used, eg in lm, failed.")
    checkTrue(all(res@outputs == "fit"))

  }


#knowing that "assign" and "<<-" indicate output
test_altoutput = function()
  {
    scr = readScript("testcode/inputtest3.R")
    res = getInputs(scr)[[1]]
    checkTrue("assigned" %in% res@outputs, "Detection of assign call as output failed.")
    checkTrue("dblarrow" %in% res@outputs, "Detection of <<- as assignment (output) failed.")
  }
  

test_libsymbols = function()
    {
        scr = readScript("testcode/inputtest4.R")
        res = getInputs(scr, collector = CodeDepends:::inputCollector(checkLibrarySymbols = TRUE))
        checkTrue( ! ( "pi" %in% res[[1]]@inputs ) , "'pi' symbol, present in base package, returned as input variable")
        checkTrue("f" %in% res[[3]]@inputs, "code-defined function f not detected as input when used as an argument to sapply in subsequent code")
        checkTrue( ! ( "rnorm" %in% res[[4]]@inputs) , "package defined functiornorm returned as input variable when used as argument to sapply")
        checkTrue("f" %in% res[[5]]@inputs, "code-defined function f not detected as input when called by subsequent code")
    }
        
