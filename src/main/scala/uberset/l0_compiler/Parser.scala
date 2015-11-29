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
            word match {
                case "" => return Program(decl, buf)
                case ";" => lineEnd(in)
                case ":" => buf.append(Label(getWord(in)))
                case "#" => decl.append(DeclVar(getWord(in)))
                case "##" => decl.append(DeclArr(getWord(in), getWord(in)))
                case "#s" => decl.append(DeclStr(getWord(in), getWord(in)))
                case "%%" => buf.append(RefSize())
                case "->" => buf.append(SetVar(getWord(in)))
                case "->>" => buf.append(CopyString(getWord(in)))
                case "." => buf.append(PrintInteger())
                case "?" => buf.append(InputInteger())
                case "+" => buf.append(AddInteger())
                case "-" => buf.append(SubI())
                case "*" => buf.append(MulI())
                case "/" => buf.append(DivI())
                case "~" => buf.append(NegI())
                case "if" => buf.append(If(getWord(in), getWord(in)))
                case ".n" => buf.append(PrintNl())
                case ".s" => buf.append(PrintString())
                case ".c" => buf.append(PrintChar())
                case "!c" => buf.append(DereferenceChar())
                case RString() => buf.append(PushString(word.substring(1, word.length-1)))
                case RInteger() => buf.append(PushShort(word.toInt))
                case "goto" => buf.append(Goto(getWord(in)))
                case "gosub" => buf.append(Gosub(getWord(in)))
                case "return" => buf.append(Return())
                case "swap" => buf.append(Swap())
                case "dup" => buf.append(Dup())
                case "drop" => buf.append(Drop())
                case RIdentifier() => buf.append(PushVar(word))
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
