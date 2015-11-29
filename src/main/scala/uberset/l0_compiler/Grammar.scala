/*
  Author: uberset
  Date: 2015-11-26
  Licence: GPL v2
*/

package uberset.l0_compiler

case class Program(declarations: Seq[Declaration], statements: Seq[Statement])

abstract sealed class Statement
case class SetVar(id: String) extends Statement
case class CopyString(id: String) extends Statement
case class RefSize() extends Statement
case class Label(id: String) extends Statement
case class Goto(id: String) extends Statement
case class If(rel: String, nr: String) extends Statement
case class Gosub(id: String) extends Statement
case class PushString(string: String) extends Statement
case class PushShort(int: Int) extends Statement
case class PushVar(id: String) extends Statement
case class PrintString() extends Statement
case class PrintChar() extends Statement
case class PrintInteger() extends Statement
case class PrintNl() extends Statement
case class InputInteger() extends Statement
case class AddInteger() extends Statement
case class SubI() extends Statement
case class MulI() extends Statement
case class DivI() extends Statement
case class NegI() extends Statement
case class Return() extends Statement
case class Swap() extends Statement
case class Dup() extends Statement
case class Drop() extends Statement
case class DereferenceChar() extends Statement

abstract sealed class Declaration
case class DeclVar(id: String) extends Declaration
case class DeclArr(id: String, size: String) extends Declaration
case class DeclStr(id: String, size: String) extends Declaration
