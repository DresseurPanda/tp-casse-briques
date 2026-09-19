extends Node2D

# Scène de la brique, chargée une seule fois au démarrage
const BRIQUE_SCENE := preload("res://Brick/brick.tscn")

# Nombre de rangées de briques à générer
@export var lignes: int = 1

# Espace horizontal entre deux briques côte à côte
@export var marge_x: float = 20.0

# Espace vertical entre deux rangées de briques
@export var marge_y: float = 25.0

# Marge sur le haut de l'écran
@export var marge_haut: float = 50.0

# Marge sur les bords
@export var marge_cotes: float = 20.0

# Liste de toutes les textures de briques disponibles (une couleur par skin)
var textures := [
	preload("res://Brick/skins/skin_brick_a.tres"),
	preload("res://Brick/skins/skin_brick_b.tres"),
	preload("res://Brick/skins/skin_brick_c.tres"),
	preload("res://Brick/skins/skin_brick_d.tres"),
	preload("res://Brick/skins/skin_brick_e.tres"),
	preload("res://Brick/skins/skin_brick_f.tres"),
	preload("res://Brick/skins/skin_brick_g.tres"),
	preload("res://Brick/skins/skin_brick_h.tres"),
	preload("res://Brick/skins/skin_brick_i.tres"),
	preload("res://Brick/skins/skin_brick_j.tres"),
	preload("res://Brick/skins/skin_brick_k.tres"),
	preload("res://Brick/skins/skin_brick_l.tres"),
	preload("res://Brick/skins/skin_brick_m.tres"),
	preload("res://Brick/skins/skin_brick_n.tres"),
	preload("res://Brick/skins/skin_brick_o.tres"),
	preload("res://Brick/skins/skin_brick_p.tres"),
	preload("res://Brick/skins/skin_brick_q.tres"),
	preload("res://Brick/skins/skin_brick_r.tres"),
	preload("res://Brick/skins/skin_brick_s.tres"),
	preload("res://Brick/skins/skin_brick_t.tres"),
	preload("res://Brick/skins/skin_brick_u.tres"),
]

func _ready() -> void:
	# Génère toute la grille de briques au lancement de la scène
	generer_briques()

func generer_briques() -> void:
	# On instancie une brique "test" juste pour mesurer sa taille réelle
	# (en tenant compte du scale appliqué sur son Sprite2D), puis on la détruit
	var brique_test := BRIQUE_SCENE.instantiate()
	var sprite_test := brique_test.get_node("Sprite2D") as Sprite2D
	var taille_brique := sprite_test.get_rect().size * sprite_test.scale
	brique_test.queue_free()
	
	# Distance totale (brique + marge) entre deux briques, horizontalement et verticalement
	var espacement_x := taille_brique.x + marge_x
	var espacement_y := taille_brique.y + marge_y
	
	# Largeur de l'écran
	var largeur_ecran := float(ProjectSettings.get_setting("display/window/size/viewport_width"))
	
	# Largeur restante une fois les marges latérales retirées
	var largeur_disponible := largeur_ecran - (marge_cotes * 2)
	
	# Nombre de colonnes qui rentrent dans la largeur disponible
	var colonnes := int(largeur_disponible / espacement_x)
	
	# Largeur réellement occupée par la grille
	var largeur_grille := colonnes * espacement_x
	
	# Décalage à appliquer pour centrer la grille horizontalement sur l'écran
	var decalage_x := (largeur_ecran - largeur_grille) / 2.0
	
	# Position de la toute première brique (en haut à gauche de la grille).
	# On ajoute la moitié de la taille de la brique car Sprite2D est en 0 0 :
	# la position du nœud correspond au centre du sprite, pas à son coin.
	var position_depart := Vector2(
		decalage_x + taille_brique.x / 2.0,
		marge_haut + taille_brique.y / 2.0
	)
	
	# Double boucle : une ligne à la fois, puis une colonne à la fois
	for ligne in range(lignes):
		for colonne in range(colonnes):
			# Instancie une nouvelle brique
			var brique := BRIQUE_SCENE.instantiate()
			
			# Calcule sa position dans la grille à partir de son numéro de ligne/colonne
			var pos := position_depart + Vector2(colonne * espacement_x, ligne * espacement_y)
			brique.position = pos
			
			# Assigne une texture aléatoire parmi toutes les couleurs disponibles
			var sprite := brique.get_node("Sprite2D") as Sprite2D
			sprite.texture = textures[randi() % textures.size()]
			
			# Ajoute la brique comme enfant de ce nœud pour qu'elle apparaisse dans la scène
			add_child(brique)
			
	# Une fois toute la grille générée, on donne le total de briques au GameManager
	GameManager.briques_restantes = lignes * colonnes
	print("Total briques générées : ", GameManager.briques_restantes)
