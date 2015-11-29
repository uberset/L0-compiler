.class public array
.super java/lang/Object
.field static a [S
.method static <clinit>()V
   .limit stack  1
   .limit locals 0
   sipush    32464
   newarray  short
   putstatic array/a [S
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
ineg
sipush 32463
getstatic array/a [S
dup_x2
pop
swap
sastore
invokestatic  java/lang/System/console()Ljava/io/Console;
invokevirtual java/io/Console/readLine()Ljava/lang/String;
invokestatic  java/lang/Integer/parseInt(Ljava/lang/String;)I
sipush 0
getstatic array/a [S
dup_x2
pop
swap
sastore
sipush 32463
getstatic array/a [S
swap
saload
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
invokevirtual java/io/PrintStream/println()V
sipush 0
getstatic array/a [S
swap
saload
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
invokevirtual java/io/PrintStream/println()V
sipush 1
getstatic array/a [S
swap
saload
getstatic java/lang/System/out Ljava/io/PrintStream;
swap
invokevirtual java/io/PrintStream/print(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
invokevirtual java/io/PrintStream/println()V
   return
.end method
