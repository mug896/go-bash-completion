## Go Bash Completion

Copy contents of `go-bash-completion.sh` file to `~/.bash_completion`.  
open new terminal and try auto completion.


```sh
bash$ go version 
go version go1.18.2 linux/amd64

bash$ go [tab]
bug       doc       fmt       help      mod       tool      work      
build     env       generate  install   run       version   
clean     fix       get       list      test      vet 

bash$ go mod [tab]
download  edit      graph     init      tidy      vendor    verify    why       

bash$ go build -[tab]
-a              -gccgoflags     -mod            -overlay        -trimpath
-asan           -gcflags        -modcacherw     -p              -v
-asmflags       -i              -modfile        -pkgdir         -work
-buildmode      -installsuffix  -msan           -race           -x
-buildvcs       -ldflags        -n              -tags           
-compiler       -linkshared     -o              -toolexec 
```
