Question 2. Solution concurrente (Go) [3 points]

 Nous vous demandons maintenant de coder la solution des Pas Japonais (Stepping Stone method) en Go. Vous devez utiliser en entrée la solution initiale telle que créée par votre programme Java. La différence principale étant que les classes sont remplacées par des types et des méthodes. Vous pouvez, bien sur, modifier la structure de votre programme.

Votre programme Go doit donc demander à l'utilisateur de spécifier un fichier texte contenant la description du problème et un fichier texte contenant la solution initiale. Ce programme doit produire un fichier texte contenant la solution trouvée et s'appelant solution.txt

De plus, ce programme doit utiliser les fonctions Go afin de trouver cette solution en utilisant la concurrence. C'est-à-dire que vous devez créer une fonction permettant d'obtenir le coût marginal d'une route en partance d'une cellule vide.

marginalCost(cell Cell, result chan Route)

Puis vous lancez l'exécution concurrente de ces fonctions en utilisant le mot clé go, pour toutes les cellules vides de l'itération courante. Le programme identifie alors la meilleure solution et exécute une nouvelle itération.

Vous devez remettre votre code source Go bien commenté, dans lequel tous les types et méthodes créés sont clairement décrits.