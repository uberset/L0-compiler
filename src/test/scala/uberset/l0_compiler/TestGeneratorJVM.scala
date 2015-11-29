/*
  Author: uberset
  Date: 2015-11-26
  Licence: GPL v2
*/

package uberset.l0_compiler

import java.io.PrintWriter


object TestGeneratorJVM {

    def main(args: Array[String]): Unit = {
        println(this.getClass.getSimpleName)
        val results = Seq(
            test("empty", ""),
            test("hello", """"Hello World!" .s .n"""),
            test("hello2",
                """"Hello " .s
                  |"World!" .s .n""".stripMargin),
            test("print1", "1 ."),
            test("print2", "32767 ."),
            test("print3", "32768 ."),
            test("add", """"5+2=" .s 5 2 + ."""),
            test("sub", """"5-2=" .s 5 2 - ."""),
            test("mul", """"5*2=" .s 5 2 * ."""),
            test("div", """"5/2=" .s 5 2 / ."""),
            test("neg", """"-5=" .s 5 ~ ."""),
            test("var", "# x x ."),
            test("sdiv", """# x 1 ~ -> x "-1/-1=" .s x x / ."""),
            test("goto1", """: 10 "Hello " .s goto 10"""),
            test("if1",
                """# i 1 -> i
                  |: 10
                  |i i * . .n
                  |i 1 + -> i
                  |i 5 if <= 10
                  |""".stripMargin),
            test("rem1", "; do nothing"),
            test("input", "# x ? -> x x 1 + . .n"),
            test("expression", """"-3+4*(5+6)*7+8-9=" .s 3 ~ 4 5 6 + * 7 * + 8 + 9 - . .n"""),
            test("gosubre",
                 """gosub 100
                   |gosub 100
                   |gosub 100
                   |goto 999
                   |: 100 "Hello!" .s .n
                   |return
                   |: 999
                   |""".stripMargin),
            test("array",
                 """## a 32464
                   |1 ~ 32463 -> a
                   |? 0 -> a
                   |32463 a . .n
                   |0 a . .n
                   |1 a . .n
                   |""".stripMargin),
            test("fornext",
                 """# i 1 -> i
                   |: 10 i i * . .n
                   |      i 2 + -> i
                   |i 9 if <= 10
                   |""".stripMargin),
            test("for1",
                 """# i 1 -> i
                   |: 10 i . .n
                   |     i 1 + -> i
                   |i 5 if <= 10
                   |""".stripMargin),
            test("swap1",
                """"2-1=" .s
                   1 2 swap - .
                """.stripMargin),
            test("alabel",
                """: loop "hello " .s goto loop
                """.stripMargin),
            test("fun1",
                """; implementing and testing a function with one argument
                  |"successor of 1 is " .s
                  |1 gosub successor .
                  |goto end
                  |: successor ; pop an integer from stack
                  |            ; push the value + 1
                  |    ; move return address down
                  |    swap    ; value, return address -> return address, value
                  |    1 +     ; value + 1
                  |    ; move return address up again
                  |    swap    ; return address, value + 1 -> value +1 , return address
                  |return
                  |: end
                """.stripMargin),
            test("recur",
                """"factorial of 5 is " .s
                  |5 gosub factorial .
                  |goto end
                  |: factorial swap dup 0 if = eins
                  |    dup 1 - gosub factorial * swap return
                  |    : eins drop 1 swap return
                  |: end
                """.stripMargin)
        )
        val tests = results.size
        val passed = results.filter(identity).size
        val failed = tests - passed
        if(failed>0)
            println(s"$failed of $tests tests failed.")
        else
            println(s"All $tests tests passed.")
    }

    def test(mainName: String, text: String): Boolean = {
        try {
            val prog = Parser.parse(text)
            val outStr = GeneratorJVM.generate(prog, mainName).mkString
            new PrintWriter("output/generatorJVM/"+mainName+".j") { write(outStr); close }
            true
        } catch {
            case e: Exception =>
                println(e.toString)
                e.printStackTrace()
                false
        }
    }

}
