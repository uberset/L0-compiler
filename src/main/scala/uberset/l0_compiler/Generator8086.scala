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
        val size = str.length
        out.append(
            s"""section .data
               |    dw $size
               |$lbl: db "$str"
               |section .text
               |push ax
               |mov ax, $lbl
               |""".stripMargin
        )
    }

    override def pushInt(v: Short): Unit = {
        // ( -> value )
        out.append(
            s"""push ax
               |mov ax,$v
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

    override def printChar(): Unit = {
        // ( char -> )
        out.append(
            """call printc
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
        // ( -> value )
        out.append(
            """push ax
              |call inputi
              |""".stripMargin
        )
    }

    override def inputString(): Unit = {
        // ( -> address )
        out.append(
            """push ax
              |call inputs
              |call println
              |""".stripMargin
        )
    }

    override def inputCharacter(): Unit = {
        // ( -> value )
        out.append(
            """push ax
              |call inputc
              |""".stripMargin
        )
    }

    override def getInt(id: String): Unit = {
        // ( -> value )
        out.append(
            s"""push ax
               |mov ax, [INT_$id]
               |""".stripMargin
        )
    }

    override def setInt(id: String): Unit = {
        // ( value -> )
        out.append(
            s"""mov [INT_$id], ax
               |pop ax
               |""".stripMargin
        )
    }

    override def getChr(id: String): Unit = {
        // ( -> value )
        out.append(
            s"""push ax
               |mov al, [CHR_$id]
               |xor ah, ah
               |""".stripMargin
        )
    }

    override def setChr(id: String): Unit = {
        // ( value -> )
        out.append(
            s"""mov [CHR_$id], al
               |pop ax
               |""".stripMargin
        )
    }

    override def copyString(): Unit = {
        // ( src dst -> )
        out.append(
            s"""mov bx, ax
               |pop ax
               |call copystr
               |pop ax
               |""".stripMargin
        )
    }

    override def compareString(): Unit = {
        // ( src dst -> [flags] )
        out.append(
            s"""mov bx, ax
               |pop ax
               |call compstr
               |pop ax
               |""".stripMargin
        )
    }

    override def refSize(): Unit = {
        // ( address -> size )
        out.append(
            s"""mov bx, ax
               |mov ax, [bx-2]
               |""".stripMargin
        )
    }

    override def getArrayRef(id: String): Unit = {
        // ( -> address )
        out.append(
            s"""push ax
               |mov ax, ARR_$id
               |""".stripMargin
        )
    }

    override def getStrRef(id: String): Unit = {
        // ( -> address )
        out.append(
            s"""push ax
               |mov ax, STR_$id
               |""".stripMargin
        )
    }

    override def setIntArr(): Unit = {
        // ( value index address -> )
        // store 2 bytes
        out.append(
            s"""mov bx, ax
               |pop si
               |shl si, 1
               |pop ax
               |mov [bx+si], ax
               |pop ax
               |""".stripMargin
        )
    }

    override def setChrArr(): Unit = {
        // ( value index address -> )
        // store 1 byte
        out.append(
            s"""mov bx, ax
               |pop si
               |pop ax
               |mov [bx+si], al
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

    override def compare(): Unit = {
        // ( a b -> [flags])

        out.append(
            s"""pop bx
               |cmp bx, ax
               |pop ax
               |""".stripMargin
        )
    }

    override def branch(rel: String, lbl: String): Unit = {
        // ( [flags] -> )
        val opcode = rel match {
            case "=" => "je"
            case "<" => "jl"
            case ">" => "jg"
            case "<=" => "jle"
            case ">=" => "jge"
            case "<>" => "jne"
        }
        val lb = labelString(lbl)

        out.append(
            s"""$opcode $lb
               |""".stripMargin
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

    override def getIntArr(): Unit = {
        // ( address, index -> word[address + 2* index] )
        out.append(
            """mov bx, ax
              |pop si
              |shl si, 1
              |mov ax, [bx + si]
              |""".stripMargin)
    }

    override def getCharArr(): Unit = {
        // ( address, index -> byte[address + index] )
        out.append(
            """mov bx, ax
              |pop si
              |mov al, [bx + si]
              |xor ah, ah
              |""".stripMargin)
    }

    private def varsAndArrays(): Unit = {
        if(!intNames.isEmpty || !arrSizes.isEmpty || !strSizes.isEmpty) {
            out.append("section .data\n")
            // define all integers in the data section
            for (id <- intNames) {
                val lbl = "INT_" + id + ":"
                out.append(
                    s"""$lbl dw 0
                       |""".stripMargin
                )
            }
            // define all characters in the data section
            for (id <- chrNames) {
                val lbl = "CHR_" + id + ":"
                out.append(
                    s"""$lbl db 0
                       |""".stripMargin
                )
            }
            // define all arrays in the data section
            for ((id, size) <- arrSizes) {
                val lbl = "ARR_" + id + ":"
                out.append(
                    s"""$lbl   times ${size} dw 0
                       |""".stripMargin
                )
            }
            // define all strings in the data section
            for ((id, size) <- strSizes) {
                val lbl = "STR_" + id + ":"
                out.append(
                    s"""       dw    ${size}
                       |       dw    0
                       |$lbl   times ${size} db 0
                       |""".stripMargin
                )
            }
            out.append("section .text\n")
        }
    }

    override def prelude(): Unit = {
        varsAndArrays()
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
