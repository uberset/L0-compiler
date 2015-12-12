package uberset.l0_compiler

import java.io.{BufferedReader, StringReader}

import scala.collection.mutable.ListBuffer

/*
  Author: uberset
  Date: 2015-11-26
  Licence: GPL v2
*/


object Parser {

    def parse(text: String): Program = parse(new BufferedReader(new StringReader(text)))

    def parse(in: BufferedReader): Program = program(in)

    def program(in: BufferedReader): Program = {
        var buf = ListBuffer[Statement]()
        var decl = ListBuffer[Declaration]()
        while(true) {
            val word: String = getWord(in)
            //println(s"($word)")

            val RString = "\"[^\"]*\"".r
            val RInteger = "[0-9]+".r
            val RIdentifier = "[a-zA-Z][a-zA-Z0-9]*".r
            val RCharacter = "'.".r
            word match {
                case "" => return Program(decl, buf)
                case ";" => lineEnd(in)
                case ":" => buf.append(Label(getWord(in)))
                case "#" => decl.append(DeclInt(getWord(in)))
                case "#c" => decl.append(DeclChr(getWord(in)))
                case "##" => decl.append(DeclArr(getWord(in), getWord(in)))
                case "#s" => decl.append(DeclStr(getWord(in), getWord(in)))
                case "%%" => buf.append(RefSize())
                case "!" => buf.append(SetIntArr())
                case "!s" => buf.append(SetChrArr())
                case "@" => buf.append(GetIntArr())
                case "@s" => buf.append(GetCharArr())
                case "->" => buf.append(SetVar(getWord(in)))
                case "->>" => buf.append(CopyString())
                case "." => buf.append(PrintInteger())
                case "?" => buf.append(InputInteger())
                case "?s" => buf.append(InputString())
                case "?c" => buf.append(InputCharacter())
                case "+" => buf.append(AddInteger())
                case "-" => buf.append(SubI())
                case "*" => buf.append(MulI())
                case "/" => buf.append(DivI())
                case "~" => buf.append(NegI())
                case ".n" => buf.append(PrintNl())
                case ".s" => buf.append(PrintString())
                case ".c" => buf.append(PrintChar())
                case RString() => buf.append(PushString(word.substring(1, word.length-1)))
                case RCharacter() => buf.append(PushCharacter(word.charAt(1)))
                case RInteger() => buf.append(PushInt(word.toInt))
                case "if" => buf.append(Compare())
                case "ifs" => buf.append(CompareString())
                case "="|"<"|">"|"<="|">="|"<>" => buf.append(Branch(word, getWord(in)))
                case "goto" => buf.append(Goto(getWord(in)))
                case "gosub" => buf.append(Gosub(getWord(in)))
                case "return" => buf.append(Return())
                case "swap" => buf.append(Swap())
                case "dup" => buf.append(Dup())
                case "s2i" => buf.append(S2I())
                case "drop" => buf.append(Drop())
                case RIdentifier() => buf.append(GetVarOrRef(word))
                case _ => throw new Exception(s"unknown word: $word")
            }
        }
        ???  // unreachable
    }

    def lineEnd(in: BufferedReader): Unit = {
        in.readLine()
    }

    def getWord(in: BufferedReader): String = {
        var i: Int = in.read()
        while(i>=0 && Character.isWhitespace(i)) {
            i = in.read()
        }
        if(i<0) return ""   // EOF
        if(i.toChar=='"') {
            // read quoted string
            var str = "\""
            i = in.read()
            while(i>=0 && i.toChar!='"') {
                str = str + i.toChar
                i = in.read()
            }
            if(i<0) return ""   // EOF
            return str+"\""  // includes the quotes
        } else {
            // read word until whitespace
            var str = ""
            while(i>=0 && !Character.isWhitespace(i)) {
                str = str + i.toChar
                i = in.read()
            }
            return str
        }
    }

}
