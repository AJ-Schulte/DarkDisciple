extends CanvasLayer

# Properties
var maxHealth : int = 100
var currentHealth : int = 100
var healthBar : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	# Find the HealthBar node
	healthBar = $HealthBar
	# Set the initial value of the progress bar
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth

# Function to update the health bar
func update_health_bar():
	# Update the value of the progress bar
	healthBar.value = currentHealth

# Function to decrease health
func decrease_health(amount):
	set_current_health(currentHealth - amount)

# Setter function for current health
func set_current_health(health):
	currentHealth = clamp(health, 0, maxHealth)
	update_health_bar()

func take_damage(amount):
	decrease_health(amount)
