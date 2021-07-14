# cryptography-tool
I. How it works
To launch the software:
- On Linux: Open a terminal and run the command ./final.sh
- On Windows: Just double click on the file

On both OS, the data dictionaries must be in the same folder as the final.sh file

In Windows there is some command which does not work, such as hashing with md5, tiger and whirlpool algorithms, we need to install them separately


II. Fonctionnalities
1- encoding: it transforms a string into ASCII code, but does not save the encoded message in a file.

2- decoding: it allows the message to be given from an ASCII code.

3- cracking a password: choose a dictionary to crack a password.

4- symmetric encryption: allows to encrypt a message with a chosen algorithm (if nothing is chosen, the default algorithm is AES256) and to save the encrypted message in a file named file.sym.txt.asc which is in the same folder as final.sh

5- asymmetric encryption: allows you to generate an existing key pair or choose an existing key, encrypt the message with this key and then save the encrypted message in a file named file.asym.txt.asc which is located in the same folder as final.sh


III. Improvements

This software works fine, but there is still room for improvements: such as choosing where to save the encrypted message, saving hashed messages, choosing different encoding algorithms, fixing windows hash bugs (md5, tiger, whirlpool), give the user the possibility of choosing a dictionary that he has in his computer for cracking a password.
