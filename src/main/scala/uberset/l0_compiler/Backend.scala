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
            case DeclInt(id: String) => declInt(id)
            case DeclChr(id: String) => declChr(id)
            case DeclArr(id: String, size: String) => declArr(id, size)
            case DeclStr(id: String, size: String) => declStr(id, size)
        }
    }

    def declInt(id: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(intNames.contains(id)) fail(s"Integer '$id' is already declared.")
        if(chrNames.contains(id)) fail(s"Character '$id' is already declared.")
        if(arrSizes.contains(id)) fail(s"Array '$id' is already declared.")
        if(strSizes.contains(id)) fail(s"String '$id' is already declared.")
        intNames += id
    }

    def declChr(id: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(intNames.contains(id)) fail(s"Integer '$id' is already declared.")
        if(chrNames.contains(id)) fail(s"Character '$id' is already declared.")
        if(arrSizes.contains(id)) fail(s"Array '$id' is already declared.")
        if(strSizes.contains(id)) fail(s"String '$id' is already declared.")
        chrNames += id
    }

    def declArr(id: String, size: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(intNames.contains(id)) fail(s"Integer '$id' is already declared.")
        if(chrNames.contains(id)) fail(s"Character '$id' is already declared.")
        if(arrSizes.contains(id)) fail(s"Array '$id' is already declared.")
        if(strSizes.contains(id)) fail(s"String '$id' is already declared.")
        try {
            val i = size.toInt
            arrSizes.put(id, i)
        } catch {
            case e: NumberFormatException => fail(s"'$size' must be a number.")
        }
    }

    def declStr(id: String, size: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(intNames.contains(id)) fail(s"Integer '$id' is already declared.")
        if(chrNames.contains(id)) fail(s"Character '$id' is already declared.")
        if(arrSizes.contains(id)) fail(s"Array '$id' is already declared.")
        if(strSizes.contains(id)) fail(s"String '$id' is already declared.")
        try {
            val i = size.toInt
            strSizes.put(id, i)
        } catch {
            case e: NumberFormatException => fail(s"'$size' must be a number.")
        }
    }

    def statement(stm: Statement): Unit = {
        stm match {
            case PushString(str) => pushString(str)
            case PushCharacter(chr) => pushInt(chr.toShort)
            case PushInt(i) => pushInt(i.toShort)
            case PrintString() => printString()
            case PrintInteger() => printInteger()
            case PrintChar() => printChar()
            case PrintNl() => printNl()
            case AddInteger() => addI()
            case SubI() => subI()
            case MulI() => mulI()
            case DivI() => divI()
            case NegI() => negI()
            case InputInteger() => inputInteger()
            case InputString() => inputString()
            case InputCharacter() => inputCharacter()
            case GetVarOrRef(id) => getVarOrRef(id)
            case SetVar(id) => setVar(id)
            case SetIntArr() => setIntArr()
            case GetIntArr() => getIntArr()
            case GetCharArr() => getCharArr()
            case CopyString() => copyString()
            case RefSize() => refSize()
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

    def getVarOrRef(id: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(intNames.contains(id))
            getInt(id)
        else if(chrNames.contains(id))
            getChr(id)
        else if(arrSizes.contains(id))
            getArrayRef(id)
        else if(strSizes.contains(id))
            getStrRef(id)
        else {
            println("intnames: "+intNames)
            println("chrNames: "+chrNames)
            fail(s"Variable '$id' is not declared.")
        }
    }

    def setVar(id: String): Unit = {
        if(id.isEmpty) fail("Variable name expected.")
        if(intNames.contains(id))
            setInt(id)
        else if(chrNames.contains(id))
            setChr(id)
        else {
            println("intnames: "+intNames)
            println("chrNames: "+chrNames)
            fail(s"Variable '$id' is not declared.")
        }
    }

    def fail(message: String): Null = throw new Exception(message)

}
