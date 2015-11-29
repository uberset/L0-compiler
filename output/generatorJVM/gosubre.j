.class public gosubre
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
jsr LBL_100
jsr LBL_100
jsr LBL_100
goto LBL_999
LBL_100:
ldc "Hello!"
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
getstatic java/lang/System/out Ljava/io/PrintStream;
invokevirtual java/io/PrintStream/println()V
astore 0
ret 0
LBL_999:
   return
.end method
