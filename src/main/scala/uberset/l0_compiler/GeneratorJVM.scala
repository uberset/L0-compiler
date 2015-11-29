/*
  Author: uberset
  Date: 2015-11-23
  Licence: GPL v2
*/

package uberset.l0_compiler


/**
  * Code generator for Java Virtual Machine.
  */
trait GeneratorJVM extends Generator {

    override def pushString(str: String): Unit = {
        out.append(
            s"""ldc "$str"
               |""".stripMargin
        )
    }

    override def pushShort(v: Short): Unit = {
        out.append(
            s"""sipush $v
                |""".stripMargin
        )
    }

    override def printString(): Unit = {
        out.append(
            """getstatic java/lang/System/out Ljava/io/PrintStream;
              |swap
              |invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
              |""".stripMargin
        )
    }

    override def printInteger(): Unit = {
        out.append(
            """getstatic java/lang/System/out Ljava/io/PrintStream;
              |swap
              |invokevirtual java/io/PrintStream/print(I)V
              |""".stripMargin
        )
    }

    override def printNl() = {
        out.append(
            """getstatic java/lang/System/out Ljava/io/PrintStream;
              |invokevirtual java/io/PrintStream/println()V
              |""".stripMargin
        )
    }

    override def addI(): Unit = {
        // pop values from stack, add them, push result to stack
        out.append("iadd\n")
    }

    override def subI(): Unit = {
        // pop values from stack, sub them, push result to stack
        out.append("isub\n")
    }

    override def mulI(): Unit = {
        // pop values from stack, mul them, push result to stack
        out.append("imul\n")
    }

    override def divI(): Unit = {
        // pop values from stack, div them, push result to stack
        out.append("idiv\n")
    }

    override def negI(): Unit = {
        // pop value from stack, neg it, push result to stack
        out.append("ineg\n")
    }

    override def inputInteger(): Unit = {
        out.append(
            """invokestatic  java/lang/System/console()Ljava/io/Console;
              |invokevirtual java/io/Console/readLine()Ljava/lang/String;
              |invokestatic  java/lang/Integer/parseInt(Ljava/lang/String;)I
              |""".stripMargin
        )
    }

    override def pushVar(id: String): Unit = {
        // read variable from data section and push the value to the stack
        out.append(
            s"getstatic ${className}/$id S\n"
        )
    }

    override def pushArr(id: String): Unit = {
        // index -> arrayref, index -> value
        out.append(
            s"""getstatic ${className}/$id [S
                |swap
                |saload
                |""".stripMargin
        )
    }

    override def setVar(id: String): Unit = {
        // pop value from stack and store in variable
        out.append(
            s"putstatic ${className}/$id S\n"
        )
    }

    override def setArr(id: String): Unit = {
        // value, index -> arrayref, index, value ->
        out.append(
            s"""getstatic ${className}/$id [S
                |dup_x2
                |pop
                |swap
                |sastore
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
        out.append(s"goto $lbl\n")
    }

    override def stmIf(rel: String, nr: String): Unit = {

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
        out.append(
            s"$opcode $lbl\n"
        )
    }

    override def gosub(nr: String): Unit = {
        val lbl = labelString(nr)
        out.append(s"jsr $lbl\n")
    }

    override def stmReturn(): Unit = {
        out.append(
            """astore 0
              |ret 0
              |""".stripMargin)
    }

    override def swap(): Unit = {
        out.append(
            """swap
              |""".stripMargin)
    }

    override def dup(): Unit = {
        out.append(
            """dup
              |""".stripMargin)
    }

    override def drop(): Unit = {
        out.append(
            """pop
              |""".stripMargin)
    }

    private def vars(): Unit = {
        // define all used variables and arrays as static class members
        for(id <- varNames)
            out.append(s".field static $id S\n")
        for(id <- arraySizes.keys)
            out.append(s".field static $id [S\n")
    }

    private def arrs(): Unit = {
        // code to allocate static arrays
        out.append(
         """.method static <clinit>()V
           |   .limit stack  1
           |   .limit locals 0
           |""".stripMargin
        )
        for((id, size) <- arraySizes)
            out.append(
                s"""   sipush    $size
                   |   newarray  short
                   |   putstatic ${className}/$id [S
                   |""".stripMargin
            )
        out.append(
         """   return
           |.end method
           |""".stripMargin
        )
    }

    override def prelude(): Unit = {
        out.append(
            s""".class public ${className}
               |.super java/lang/Object
               |""".stripMargin)
        vars()
        arrs()
        out.append(
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

    override def end(): Unit = {
        out.append(
            """   return
              |.end method
              |""".stripMargin
        )
    }

}
