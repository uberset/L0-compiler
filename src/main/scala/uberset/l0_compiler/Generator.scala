/*
  Author: uberset
  Date: 2015-11-28
  Licence: GPL v2
*/

package uberset.l0_compiler

import scala.collection.mutable
import scala.collection.mutable.ListBuffer

trait Generator {

    val className: String

    val out = ListBuffer[String]()
    var varNames = Set[String]()
    var arrSizes = mutable.HashMap[String, Int]()
    var strSizes = mutable.HashMap[String, Int]()

    def prelude(): Unit
    def end(): Unit
    def pushString(str: String): Unit
    def pushShort(v: Short): Unit
    def pushVar(id: String): Unit
    def pushArr(id: String): Unit
    def pushStr(id: String): Unit
    def setVar(id: String): Unit
    def setArr(id: String): Unit
    def copyString(id: String): Unit
    def refSize(): Unit
    def printString(): Unit
    def printInteger(): Unit
    def printChar(): Unit
    def printNl(): Unit
    def addI(): Unit
    def subI(): Unit
    def mulI(): Unit
    def divI(): Unit
    def negI(): Unit
    def inputInteger(): Unit
    def label(nr: String): Unit
    def goto(nr: String): Unit
    def stmIf(rel: String, nr: String): Unit
    def gosub(nr: String): Unit
    def stmReturn(): Unit
    def swap(): Unit
    def dup(): Unit
    def drop(): Unit
    def dereferenceChar(): Unit

}
