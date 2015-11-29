.class public goto1
.super java/lang/Object
.method static <clinit>()V
   .limit stack  1
   .limit locals 0
   return
.end method
.method public <init>()V
   aload_0
   invokenonvirtual java/lang/Object/<init>()V
   return
.end method
.method public static main([Ljava/lang/String;)V
   .limit stack 10000
LBL_10:
ldc "Hello "
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
goto LBL_10
   return
.end method
