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
    var intNames = Set[String]()
    var chrNames = Set[String]()
    var arrSizes = mutable.HashMap[String, Int]()
    var strSizes = mutable.HashMap[String, Int]()

    def prelude(): Unit
    def end(): Unit
    def pushString(str: String): Unit
    def pushInt(v: Short): Unit
    def setInt(id: String): Unit
    def getInt(id: String): Unit
    def setChr(id: String): Unit
    def getChr(id: String): Unit
    def getArrayRef(id: String): Unit
    def setIntArr(): Unit
    def setChrArr(): Unit
    def getIntArr(): Unit
    def getStrRef(id: String): Unit
    def getCharArr(): Unit
    def copyString(): Unit
    def compareString(): Unit
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
    def inputString(): Unit
    def inputCharacter(): Unit
    def label(nr: String): Unit
    def goto(nr: String): Unit
    def compare(): Unit
    def branch(rel: String, lbl: String): Unit
    def gosub(nr: String): Unit
    def stmReturn(): Unit
    def swap(): Unit
    def dup(): Unit
    def drop(): Unit

}
