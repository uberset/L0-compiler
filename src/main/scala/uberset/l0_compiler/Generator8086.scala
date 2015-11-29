/*
  Author: uberset
  Date: 2015-11-26
  Licence: GPL v2
*/

package uberset.l0_compiler

/**
  * Code generator for Java Virtual Machine.
  */
trait Generator8086 extends Generator {

    var dataCount: Int = 0

    override def pushString(str: String): Unit = {
        // ( -> address )
        val nr = dataCount; dataCount += 1
        val lbl = s"DATA_$nr"
        out.append(
            s"""section .data
               |$lbl: db "$str", 0
               |section .text
               |push ax
               |mov ax, $lbl
               |""".stripMargin
        )
    }

    override def pushShort(v: Short): Unit = {
        // ( -> value )
        out.append(
            s"""push ax
               |mov ax ,$v
               |""".stripMargin
        )
    }

    override def printString(): Unit = {
        // ( address -> )
        out.append(
            """call prints
              |pop ax
              |""".stripMargin
        )
    }

    override def printInteger(): Unit = {
        // ( value -> )
        out.append(
            """call printi
              |pop ax
              |""".stripMargin
        )
    }

    override def printNl() = {
        // ( -> )
        out.append(
            """call println
              |""".stripMargin
        )
    }

    override def addI(): Unit = {
        // ( a b -> a + b )
        out.append(
            """mov bx, ax
              |pop ax
              |add ax, bx
              |""".stripMargin)
    }

    override def subI(): Unit = {
        // ( a b -> a - b )
        out.append(
            """mov bx, ax
              |pop ax
              |sub ax, bx
              |""".stripMargin)
    }

    override def mulI(): Unit = {
        // ( a b -> a * b )
        out.append(
            """mov bx, ax
              |pop ax
              |imul ax, bx
              |""".stripMargin)
    }

    override def divI(): Unit = {
        // ( a b -> a / b )
        out.append(
            """mov bx, ax
              |pop ax
              |cwd
              |idiv bx
              |""".stripMargin)
    }

    override def negI(): Unit = {
        // ( a -> - a )
        out.append(
            """neg ax
              |""".stripMargin)
    }

    override def inputInteger(): Unit = {
        // ( -> value)
        out.append(
            """push ax
              |call inputi
              |""".stripMargin
        )
    }

    override def pushVar(id: String): Unit = {
        // ( -> value )
        out.append(
            s"""push ax
               |mov ax, [VAR_$id]
               |""".stripMargin
        )
    }

    override def setVar(id: String): Unit = {
        // ( value -> )
        out.append(
            s"""mov [VAR_$id], ax
               |pop ax
               |""".stripMargin
        )
    }

    override def pushArr(id: String): Unit = {
        // ( index -> value )
        out.append(
            s"""mov si, ax
               |shl si, 1
               |mov ax, [ARR_$id+si]
               |""".stripMargin
        )
    }

    override def setArr(id: String): Unit = {
        // ( value index -> )
        out.append(
            s"""mov si, ax
               |shl si, 1
               |pop ax
               |mov [ARR_$id+si], ax
               |pop ax
               |""".stripMargin
        )
    }

    override def label(nr: String) = {
        val lbl = labelString(nr)
        out.append(s"$lbl:\n")
    }

    private def labelString(lbl: String) = {
        s"LBL_$lbl"
    }

    override def goto(nr: String): Unit = {
        val lbl = labelString(nr)
        out.append(s"jmp $lbl\n")
    }

    override def stmIf(rel: String, nr: String): Unit = {
        // ( a b -> )
        val opcode = rel match {
            case "=" => "je"
            case "<" => "jlt"
            case ">" => "jgt"
            case "<=" => "jle"
            case ">=" => "jge"
            case "<>" => "jne"
        }
        val lbl = labelString(nr)

        out.append(
            s"""pop bx
               |cmp bx, ax
               |pop ax
               |$opcode $lbl
             """.stripMargin
        )
    }

    override def gosub(nr: String): Unit = {
        val lbl = labelString(nr)
        out.append(s"call $lbl\n")
    }

    override def stmReturn(): Unit = {
        out.append(
            """ret
              |""".stripMargin)
    }

    override def swap(): Unit = {
        // ( a b -> b a )
        out.append(
            """mov bx, ax
              |pop ax
              |push bx
              |""".stripMargin)
    }

    override def dup(): Unit = {
        // ( a -> a a )
        out.append(
            """push ax
              |""".stripMargin)
    }

    override def drop(): Unit = {
        // ( a -> )
        out.append(
            """pop ax
              |""".stripMargin)
    }

    private def vars(): Unit = {
        if(!varNames.isEmpty) {
            // define all used variables in the data section
            out.append("section .data\n")
            for (id <- varNames) {
                val lbl = "VAR_" + id + ":"
                out.append(
                    s"""$lbl dw 0
                       |""".stripMargin
                )
            }
            out.append("section .text\n")
        }
    }

    private def arrs(): Unit = {
        if(!arraySizes.isEmpty) {
            // define all used arrays in the data section
            out.append("section .data\n")
            for ((id, size) <- arraySizes) {
                val lbl = "ARR_" + id + ":"
                out.append(
                    s"""$lbl   times ${size} dw 0
                       |""".stripMargin
                )
            }
            out.append("section .text\n")
        }
    }

    override def prelude(): Unit = {
        vars()
        arrs()
        out.append(
            s"""org 100h
               |mov ax, -1
               |""".stripMargin
        )
    }

    override def end(): Unit = {
        out.append(
            """mov ax,0x4c00
              |int 0x21
              |""".stripMargin
        )
        Library8086.library(out)
    }

}
