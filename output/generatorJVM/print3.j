.class public print3
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
sipush -32768
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
   return
.end method
