.class public fornext
.super java/lang/Object
.field static i S
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
sipush 1
putstatic fornext/i S
LBL_10:
getstatic fornext/i S
getstatic fornext/i S
imul
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
invokevirtual java/io/PrintStream/println()V
getstatic fornext/i S
sipush 2
iadd
putstatic fornext/i S
getstatic fornext/i S
sipush 9
if_icmple LBL_10
   return
.end method
