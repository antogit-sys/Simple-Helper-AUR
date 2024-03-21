<h1 align = "center"> Simple Helper AUR (shaur) 🦅 </h1>
<h1 align = "center">
    <img src='img/banner_shaur.png'/>
</h1>

<hr>
<p> Indice </p>
<a href='#s1'>test 3</a>

## 1. Introdution 🚀

**SHAUR**,  acronym for **S**imple **H**elper **AUR**, is a very minimal and functional AUR helper. Its task is to greatly simplify what well-known AUR helpers do, adding many more functionalities like AUR package tracking. Imagine tackling the climb of Everest: while other AUR helpers force you to struggle along steep and rugged slopes, with Shaur it's like having wings. It lifts you towards the highest peaks with astonishing speed, overcoming every obstacle along the way and taking you directly to the AUR summit without even feeling the fatigue of the ascent.

## 2. Security Notes 📄🛡️

For security reasons, SHAUR cannot be executed or installed directly by the root user. However, this does not mean that SHAUR does not make use of elevated privileges. In fact, it only utilizes such privileges for specific operations such as **removing** AUR packages from the system and **updating** local packages. 

While most AUR helpers advise against running as the root user, **SHAUR enforces, for security reasons, the necessity of always operating as a normal user.** This control was personally implemented prior to the introduction of a requests handler in the form of an anonymous function.

## 3. Requires System 🖥️

1) **Operation System:** Arch linux and derivatives

2) **Shell:** Bash

3) **Package Manager:** Pacman 

## 4. installation (!usermode)

1) clone the repository

```bash
git clone https://github.com/antogit-sys/Simple-Helper-AUR.git
```

2. go to Simple-Helper-AUR/

```bash
cd Simple-Helper-AUR/
```

<a name="s1">
3. install shaur
   
   *Note: Execute the install.sh file in user mode, otherwise it will not start.*

```bash
bash install.sh
```

 and wait a few seconds

<img src="img/dialog_shaur.png" />

*Proceed with the Enter key*.



<img src="img/install_shaur.png" />

*To invoke SHAUR, type 'shaur' or 'shaur help' or 'shaur --help' or 'shaur -h' or 'shaur help'.*

```bash
$ shaur help
```
