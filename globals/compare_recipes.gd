extends Node

func compare_recipes(original_recipe, player_recipe, feedback):
	var num_ingredients = float(len(original_recipe))
	var feedback_to_give = []
	var wrong_ingredients = 0
	for k in original_recipe.keys():
		if k not in player_recipe.keys():
			wrong_ingredients += 1
			feedback_to_give = update_feedback(feedback, feedback_to_give, "missing_ingredient", 0)
		else:
			if original_recipe[k] > player_recipe[k]:
				wrong_ingredients += 1
				feedback_to_give = update_feedback(feedback, feedback_to_give, k, 0)
			elif original_recipe[k] < player_recipe[k]:
				wrong_ingredients += 1
				feedback_to_give = update_feedback(feedback, feedback_to_give, k, 1)
	if wrong_ingredient_used(original_recipe, player_recipe):
		wrong_ingredients += 5
		feedback_to_give = update_feedback(feedback, feedback_to_give, "bad_ingredient", 0)

	var score = wrong_ingredients/num_ingredients

	if score == 0:
		return ["Perfect", finalize_feedback(feedback_to_give)]
	elif score < 0.35 :
		return ["Good", finalize_feedback(feedback_to_give)]
	elif score <= 0.5:
		return ["Okay", finalize_feedback(feedback_to_give)]
	else :
		return ["Bad", finalize_feedback(feedback_to_give)]


func finalize_feedback(feedback_to_give):
	var final_feedback = ""
	for sub in feedback_to_give.slice(0, len(feedback_to_give) - 1):
		if len(sub) > 0 and sub[-1] != ".":
			final_feedback += sub + ", "
		elif len(sub) > 0:
			final_feedback += sub + " "
	if len(feedback_to_give) > 1:
		final_feedback += "and "
	if len(feedback_to_give) > 0:
		final_feedback += feedback_to_give[len(feedback_to_give) - 1]
		return final_feedback[0].to_upper() + final_feedback.substr(1,-1) +"."

func update_feedback(feedback, feedback_to_give, key, index):
	if feedback[key] not in feedback_to_give:
		feedback_to_give.append(feedback[key][index])
	return feedback_to_give
	
func wrong_ingredient_used(original_recipe, player_recipe):
	for k in player_recipe.keys():
		if k not in original_recipe.keys():
			return true
	return false
