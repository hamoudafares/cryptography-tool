#!/bin/bash
clear
choice=1
while [ $choice -ne 6 ] 
do
        clear
        echo "===OUTIL SSI_INSAT POUR LA CRYPTOGRAPHIE==="
        echo "1- Codage et Decodage d' un message : "
        echo "2- Hachage d'un message :"
        echo "3- Craquage d'un message hache : "
        echo "4- Chiffrement et dechiffrement Symetrique d'un message : "
        echo "5- Chiffrement et dechiffrement Asymetrique d' un message : "
        echo "6- Quitter"

read choice;
case $choice in
        1)clear
        echo "1- Coder un message"
        echo "2- Decoder un message"
        read codec
        case $codec in
                1) echo "Saisir le message à coder : "
		ord() {
  		LC_CTYPE=C printf '%d' "'$1"
		}
                encoded=""
                while read -n1 c; do
                        res=$(ord $c)
                        if [[ -z $c ]]; then break; fi
                        if [ $res -lt "100" ]
                        then
                                res="0$res"
                        fi
                        if [ $res -lt "10"  ]
                        then
                                res="0$res"
                        fi
                        encoded="$encoded$res"
                done
                echo $encoded 
		;;
                2) echo "Saisir le message à décoder"
                chr() {
                [ "$1" -lt 256 ] || return 1
                printf "\\$(printf '%03o' "$1")"
                }
                word=""
                while read -n3 v; do
                if [[ -z $v ]]; then break; fi
                v=$(echo $v | sed 's/^0*//')
                res=$(chr $v)
                word="$word$res"
                done
                echo $word ;;  
		*) exit ;;
                esac
		;;
		2)
		clear
		echo "Saisir le message : "
		read message
		echo "Choisir la fonction de hachage :"
		echo "1- md5"
		echo "2- sha512"
		echo "3- tiger"
		echo "4- whirlpool"
		read hash
		case $hash in
			1) echo -n $message | md5deep | awk '{print $1}' ;;
                	2) echo -n $message | sha512sum | awk '{print $1}';;
                	3) echo -n $message | tigerdeep | awk '{print $1}';;
                	4) echo -n $message | whirlpooldeep | awk '{print $1}';;
			*) exit ;;
		esac
		;;
		3)
		echo "donner le mot de passe à craquer " 
echo "le mot de passe doit être hashé par l'une de ces fonctions : md5 / sha512 / tiger / whirlpool"
read password
length=$(expr length "$password")
if [ $length = 32 ] 
then  
        hasher=md5deep 
elif [ $length = 48 ] 
then 
        hasher=tigerdeep 
elif [ $length = 128 ] 
then
        echo "1) whirlpooldeep  "
        echo "2) sha512sum "
        echo "3) je sais pas (moins optimisé parcequ'on va essayer les deux)"
read choice
case $choice in 
        1)hasher=whirlpooldeep;;
        2)hasher=sha512sum;;
        3)hasher=both;; 
        *)exit;;
esac
else
        echo "ce mot de passe ne peut pas être crypté"
        exit
fi

echo "choisir un dictonnaire"
echo "1) rockyou.txt"
echo "2) 10-million-combos.txt"
read choice
case $choice in
        1) dict="rockyou.txt";;
        2) dict="10-million-combos.txt";;
        *)exit;;
esac
if [ $hasher = "both" ]
then
while  read line  ;do
    for word in $line; do
        encryptedword=$(echo -n $word | whirlpooldeep | awk '{print $1}')
        if [ $encryptedword = $password ]
        then
                echo "le mot de passe craqué est : $word"
		exit
        fi
        encryptedword=$(echo -n $word | sha512sum | awk '{print $1}')
        if [ $encryptedword = $password ]
        then
                echo "le mot de passe craqué est : $word"
		exit
        fi

    done     
  done < $dict
else
while  read line ;do
    for word in $line; do
        encryptedword=$(echo -n $word | $hasher | awk '{print $1}')
        if [ $encryptedword = $password ]
        then
                echo "le mot de passe craqué est : $word"
                exit
	
      fi
    done
done < $dict
fi
;;
4) clear
echo "1- Chiffrer"
echo "2- Dechiffrer"
read choice
case $choice in
    1)clear
        echo "Saisir le message a chiffer: "
        read message
        echo "Choisir l'algorithme de chiffrement symetrique:"
        echo "1- AES256"
        echo "2- 3DES"
        echo "3- BLOWFISH"
        echo "4- CAMELLIA256"
        echo "5- TWOFISH"
        read symalgo
        case $symalgo in
            1) algo='AES256' ;;
            2) algo='3DES' ;;
            3) algo='BLOWFISH' ;;
            4) algo='CAMELLIA256' ;;
            5) algo='TWOFISH' ;;
            *) algo='AES256' ;;
        esac
        echo $message > file.sym.txt
        gpg --symmetric -a --cipher-algo $algo file.sym.txt
        cat file.sym.txt.asc
        echo "----------------------------------"
        echo "Vous trouverez le message chiffré dans un fihier nommé file.sym.txt.asc"
        echo "Si vous voulez le sauvegarder, veuillez le copier dans un autre directory"
        ;;
    2)clear
        echo "Saisir le path du fichier a dechiffrer"
        read file
        gpg -d $file
        ;;
    esac ;;
5) clear
echo "1- Chiffrer"
echo "2- Dechiffrer"
read choice
case $choice in
    1) clear
        echo "1- Generer une nouvelle paire de clé"
        echo "2- Utiliser une clé existante"
        read choice
        case $choice in
            1) gpg --full-generate-key ;;
            2) gpg --list-keys ;;
        esac
        echo "Veuillez saisir l'id de votre clé:"
        read key
        echo "Veuillez saisir le message a chiffrer:"
        read message
        echo $message > file.asym.txt
        gpg -a -r $key -e file.asym.txt
        cat file.asym.txt.asc
        echo "----------------------------------"
        echo "Vous trouverez le message chiffré dans un fihier nommé file.asym.txt.asc"
        echo "Si vous voulez le sauvegarder, veuillez le copier dans un autre directory"
        ;;
    2)clear
        echo "Saisir le path du fichier a dechiffrer"
        read file
        gpg -d $file
    ;;
    esac
    ;;
		6) exit ;;
		*) exit ;;
		esac
echo ""
echo "-----------------------------------"
echo "(cliquer sur n'importe quelle touche)"
read x 
done

