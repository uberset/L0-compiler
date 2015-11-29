/*
  Author: uberset
  Date: 2015-11-23
  Licence: GPL v2
*/

package uberset.l0_compiler

import scala.collection.mutable
import scala.collection.mutable.ListBuffer


/**
  * Code generator for Java Virtual Machine.
  */
object GeneratorJVM {

    case class Status(
        className: String,
        var dataCount: Int = 0,
        var lblCount: Int = 0,
        var varNames: Set[String] = Set(),
        var arraySizes: mutable.Map[String, Int] = mutable.HashMap[String, Int](),
        out: ListBuffer[String] = ListBuffer[String]()
    )

    def generate(p: Program, className: String): Seq[String] = {
        val s = Status(className)
        programm(p, s)
        s.out
    }

    def programm(prog: Program, s: Status): Unit = {
        for(dcl <- prog.declarations) {
            declaration(dcl, s)
        }
        prelude(s)
        for(stm <- prog.statements) {
            statement(stm, s)
        }
        end(s)
    }

    def declaration(dcl: Declaration, s: Status) = {
        dcl match {
            case DeclVar(id: String) => declVar(id,s)
            case DeclArr(id: String, size: String) => declArr(id, size, s)
        }
    }

    def statement(stm: Statement, s: Status) = {
        stm match {
            case PushString(str) => pushString(str, s)
            case PushShort(i) => pushShort(i.toShort, s)
            case PrintString() => printString(s)
            case PrintInteger() => printInteger(s)
            case PrintNl() => printNl(s)
            case AddInteger() => addI(s)
            case SubI() => subI(s)
            case MulI() => mulI(s)
            case DivI() => divI(s)
            case NegI() => negI(s)
            case InputInteger() => inputInteger(s)
            case PushVar(id) => pushVarOrArray(id, s)
            case SetVar(id) => setVarOrArray(id, s)
            case Label(nr: String) => label(nr, s)
            case Goto(nr: String) => goto(nr, s)
            case If(rel: String, nr: String) => stmIf(rel, nr, s)
            case Gosub(nr: String) => gosub(nr, s)
            case Return() => stmReturn(s)
        }
    }

    def pushString(str: String, s: Status): Unit = {
        s.out.append(
            s"""ldc "$str"
               |""".stripMargin
        )
    }

    def pushShort(v: Short, s: Status): Unit = {
        s.out.append(
            s"""sipush $v
                |""".stripMargin
        )
    }

    def printString(s: Status): Unit = {
        s.out.append(
            """getstatic java/lang/System/out Ljava/io/PrintStream;
              |swap
              |invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
              |""".stripMargin
        )
    }

    def printInteger(s: Status): Unit = {
        s.out.append(
            """getstatic java/lang/System/out Ljava/io/PrintStream;
              |swap
              |invokevirtual java/io/PrintStream/print(I)V
              |""".stripMargin
        )
    }

    def printNl(s: Status) = {
        s.out.append(
            """getstatic java/lang/System/out Ljava/io/PrintStream;
              |invokevirtual java/io/PrintStream/println()V
              |""".stripMargin
        )
    }

    def addI(s: Status): Unit = {
        // pop values from stack, add them, push result to stack
        s.out.append("iadd\n")
    }

    def subI(s: Status): Unit = {
        // pop values from stack, sub them, push result to stack
        s.out.append("isub\n")
    }

    def mulI(s: Status): Unit = {
        // pop values from stack, mul them, push result to stack
        s.out.append("imul\n")
    }

    def divI(s: Status): Unit = {
        // pop values from stack, div them, push result to stack
        s.out.append("idiv\n")
    }

    def negI(s: Status): Unit = {
        // pop value from stack, neg it, push result to stack
        s.out.append("ineg\n")
    }

    def inputInteger(s: Status): Unit = {
        s.out.append(
            """invokestatic  java/lang/System/console()Ljava/io/Console;
              |invokevirtual java/io/Console/readLine()Ljava/lang/String;
              |invokestatic  java/lang/Integer/parseInt(Ljava/lang/String;)I
              |""".stripMargin
        )
    }

    def declVar(id: String, s: Status): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(s.varNames.contains(id)) fail(s"Variable '$id' is already declared")
        if(s.arraySizes.contains(id)) fail(s"Array '$id' is already declared")
        s.varNames += id
    }

    def declArr(id: String, size: String, s: Status) = {
        if(id.isEmpty) fail("Variable name expected.")
        if(s.varNames.contains(id)) fail(s"Variable '$id' is already declared")
        if(s.arraySizes.contains(id)) fail(s"Array '$id' is already declared")
        try {
            val i = size.toInt
            s.arraySizes.put(id, i)
        } catch {
            case e: NumberFormatException => fail(s"Label '$size' must be a number.")
        }
    }

    def pushVarOrArray(id: String, s: Status) = {
        if(id.isEmpty) fail("Variable name expected.")
        if(s.varNames.contains(id))
            pushVar(id, s)
        else if(s.arraySizes.contains(id))
            pushArr(id, s)
        else
            fail(s"Variable '$id' is not declared")
    }

    def pushVar(id: String, s: Status): Unit = {
        // read variable from data section and push the value to the stack
        s.out.append(
            s"getstatic ${s.className}/$id S\n"
        )
    }

    def pushArr(id: String, s: Status): Unit = {
        // index -> arrayref, index -> value
        s.out.append(
            s"""getstatic ${s.className}/$id [S
                |swap
                |saload
                |""".stripMargin
        )
    }

    def setVarOrArray(id: String, s: Status) = {
        if(id.isEmpty) fail("Variable name expected.")
        if(s.varNames.contains(id))
            setVar(id, s)
        else if(s.arraySizes.contains(id))
            setArr(id, s)
        else
            fail(s"Variable '$id' is not declared")
    }

    def setVar(id: String, s: Status): Unit = {
        // read variable from data section and push the value to the stack
        s.out.append(
            s"putstatic ${s.className}/$id S\n"
        )
    }

    def setArr(id: String, s: Status): Unit = {
        // value, index -> arrayref, index, value ->
        s.out.append(
            s"""getstatic ${s.className}/$id [S
                |dup_x2
                |pop
                |swap
                |sastore
                |""".stripMargin
        )
    }

    def label(nr: String, s: Status) = {
        val lbl = labelString(nr)
        s.out.append(s"$lbl:\n")
    }

    def labelString(nr: String) = {
        try {
            val i = nr.toInt
            s"LBL_$i"
        } catch {
            case e: NumberFormatException => fail(s"Label '$nr' must be a number.")
        }
    }

    def goto(nr: String, s: Status): Unit = {
        val lbl = labelString(nr)
        s.out.append(s"goto $lbl\n")
    }

    def stmIf(rel: String, nr: String, s: Status): Unit = {

        val opcode = rel match {
            case "=" => "if_icmpeq"
            case "<>" => "if_icmpne"
            case ">" => "if_icmpgt"
            case "<" => "if_icmplt"
            case ">=" => "if_icmpge"
            case "<=" => "if_icmple"
        }
        val lbl = labelString(nr)

        // pop values from stack, cmp them and jump on condition
        s.out.append(
            s"$opcode $lbl\n"
        )
    }

    def gosub(nr: String, s: Status): Unit = {
        val lbl = labelString(nr)
        s.out.append(s"jsr $lbl\n")
    }

    def stmReturn(s: Status): Unit = {
        s.out.append(
            """astore 0
              |ret 0
              |""".stripMargin)
    }

    def vars(s: Status): Unit = {
        // define all used variables and arrays as static class members
        for(id <- s.varNames)
            s.out.append(s".field static $id S\n")
        for(id <- s.arraySizes.keys)
            s.out.append(s".field static $id [S\n")
    }

    def arrs(s: Status): Unit = {
        // code to allocate static arrays
        s.out.append(
         """.method static <clinit>()V
           |   .limit stack  1
           |   .limit locals 0
           |""".stripMargin
        )
        for((id, size) <- s.arraySizes)
            s.out.append(
                s"""   sipush    $size
                   |   newarray  short
                   |   putstatic ${s.className}/$id [S
                   |""".stripMargin
            )
        s.out.append(
         """   return
           |.end method
           |""".stripMargin
        )
    }

    def end(s: Status): Unit = {
        s.out.append(
            """   return
              |.end method
              |""".stripMargin
            )
    }

    def prelude(s: Status): Unit = {
        s.out.append(
            s""".class public ${s.className}
               |.super java/lang/Object
               |""".stripMargin)
        vars(s)
        arrs(s)
        s.out.append(
            s""".method public <init>()V
               |   aload_0
               |   invokenonvirtual java/lang/Object/<init>()V
               |   return
               |.end method
               |.method public static main([Ljava/lang/String;)V
               |   .limit stack 10000
               |""".stripMargin
        )
    }

    def fail(message: String): Null = throw new Exception(message)

}
