/*
  Author: uberset
  Date: 2015-11-26
  Licence: GPL v2
*/

package uberset.l0_compiler

import java.io.PrintWriter


object TestGenerator8086 {

    def main(args: Array[String]): Unit = {
        println(this.getClass.getSimpleName)
        val results = Seq(
            test("empty"),
            test("hello"),
            test("hello2"),
            test("hello3"),
            test("print1"),
            test("print2"),
            test("print3"),
            test("add"),
            test("sub"),
            test("mul"),
            test("div"),
            test("neg"),
            test("var"),
            test("sdiv"),
            test("goto1"),
            test("if1"),
            test("rem1"),
            test("input"),
            test("input1"),
            test("expression"),
            test("gosubre"),
            test("array0"),
            test("array"),
            test("fornext"),
            test("for1"),
            test("swap"),
            test("dup"),
            test("drop"),
            test("alabel"),
            test("fun1"),
            test("recur"),
            test("string"),
            test("instr"),
            test("inchar"),
            test("charlit")
        )
        val tests = results.size
        val passed = results.filter(identity).size
        val failed = tests - passed
        if(failed>0)
            println(s"$failed of $tests tests failed.")
        else
            println(s"All $tests tests passed.")
    }

    def test(mainName: String, dummy: String = ""): Boolean = {
        try {
            val text: String = scala.io.Source.fromFile("input/"+mainName+".l0").getLines.mkString("\n")
            println(mainName);println(text); println("--------------------")
            val prog = Parser.parse(text)
            val outStr: String = (new Backend(mainName) with Generator8086).generate(prog).mkString
            new PrintWriter("output/generator8086/"+mainName+".asm") { write(outStr); close }
            true
        } catch {
            case e: Exception =>
                println(e.toString)
                e.printStackTrace()
                false
        }
    }

}
