/*
  Author: uberset
  Date: 2015-11-28
  Licence: GPL v2
*/

package uberset.l0_compiler


class Backend(programName : String) { this: Generator =>

    override val className = programName

    def generate(p: Program): Seq[String] = {
        programm(p)
        out
    }

    def programm(prog: Program): Unit = {
        for(dcl <- prog.declarations) {
            declaration(dcl)
        }
        prelude()
        for(stm <- prog.statements) {
            statement(stm)
        }
        end()
    }

    def declaration(dcl: Declaration): Unit = {
        dcl match {
            case DeclVar(id: String) => declVar(id)
            case DeclArr(id: String, size: String) => declArr(id, size)
        }
    }

    def declVar(id: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(varNames.contains(id)) fail(s"Variable '$id' is already declared")
        if(arraySizes.contains(id)) fail(s"Array '$id' is already declared")
        varNames += id
    }

    def declArr(id: String, size: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(varNames.contains(id)) fail(s"Variable '$id' is already declared")
        if(arraySizes.contains(id)) fail(s"Array '$id' is already declared")
        try {
            val i = size.toInt
            arraySizes.put(id, i)
        } catch {
            case e: NumberFormatException => fail(s"Label '$size' must be a number.")
        }
    }

    def statement(stm: Statement): Unit = {
        stm match {
            case PushString(str) => pushString(str)
            case PushShort(i) => pushShort(i.toShort)
            case PrintString() => printString()
            case PrintInteger() => printInteger()
            case PrintNl() => printNl()
            case AddInteger() => addI()
            case SubI() => subI()
            case MulI() => mulI()
            case DivI() => divI()
            case NegI() => negI()
            case InputInteger() => inputInteger()
            case PushVar(id) => pushVarOrArray(id)
            case SetVar(id) => setVarOrArray(id)
            case Label(nr: String) => label(nr)
            case Goto(nr: String) => goto(nr)
            case If(rel: String, nr: String) => stmIf(rel, nr)
            case Gosub(nr: String) => gosub(nr)
            case Return() => stmReturn()
            case Swap() => swap()
            case Dup() => dup()
            case Drop() => drop()
        }
    }

    def pushVarOrArray(id: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(varNames.contains(id))
            pushVar(id)
        else if(arraySizes.contains(id))
            pushArr(id)
        else
            fail(s"Variable '$id' is not declared")
    }

    def setVarOrArray(id: String) = {
        if(id.isEmpty) fail("Variable name expected.")
        if(varNames.contains(id))
            setVar(id)
        else if(arraySizes.contains(id))
            setArr(id)
        else
            fail(s"Variable '$id' is not declared")
    }

    def fail(message: String): Null = throw new Exception(message)

}
