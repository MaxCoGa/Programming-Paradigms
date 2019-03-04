Question 2. Solution concurrente (Go) [3 points]

 Nous vous demandons maintenant de coder la solution des Pas Japonais (Stepping Stone method) en Go. Vous devez utiliser en entr�e la solution initiale telle que cr��e par votre programme Java. La diff�rence principale �tant que les classes sont remplac�es par des types et des m�thodes. Vous pouvez, bien sur, modifier la structure de votre programme.

Votre programme Go doit donc demander � l'utilisateur de sp�cifier un fichier texte contenant la description du probl�me et un fichier texte contenant la solution initiale. Ce programme doit produire un fichier texte contenant la solution trouv�e et s'appelant solution.txt

De plus, ce programme doit utiliser les fonctions Go afin de trouver cette solution en utilisant la concurrence. C'est-�-dire que vous devez cr�er une fonction permettant d'obtenir le co�t marginal d'une route en partance d'une cellule vide.

marginalCost(cell Cell, result chan Route)

Puis vous lancez l'ex�cution concurrente de ces fonctions en utilisant le mot cl� go, pour toutes les cellules vides de l'it�ration courante. Le programme identifie alors la meilleure solution et ex�cute une nouvelle it�ration.

Vous devez remettre votre code source Go bien comment�, dans lequel tous les types et m�thodes cr��s sont clairement d�crits.