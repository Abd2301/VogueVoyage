def suggest_clothing_style(body_shape, skin_tone, clothing_color, occasion, clothes_to_wear):
    # Rule-based suggestions
    suggestions = []

    #rule for different clothing
    if clothes_to_wear == "Jeans" and occasion == "casual":
        suggestions.append("You should go with Tshirt")

    # Rule 1: Body Shape
    if body_shape == "Ectomorph":
        suggestions.append("Choose well-fitted clothing to avoid appearing overly thin,Layering can add dimension to the frame.")
    elif body_shape == "Mesomorph":
        suggestions.append("Tailored and fitted clothing enhances the natural athletic shape,V-neck tops can accentuate the chest without appearing too bulky,with taper jeans.")
    elif body_shape == "Endomorph":
        suggestions.append("Opt for structured jackets and blazers to create a more defined silhouette,A-line dresses and skirts can be flattering,Darker colors and vertical stripes can have a slimming effect")
    

    # Rule 2: Skin Tone and Clothing Color
    if skin_tone == "fair":
        if clothing_color in ["pastels", "earth tones"]:
            suggestions.append("Choose pastel or earth-toned clothing to complement your fair skin.")
        else:
            suggestions.append("Avoid overly dark colors that may contrast sharply with your fair skin.")
    elif skin_tone == "medium":
        if clothing_color in ["jewel tones", "warm colors"]:
            suggestions.append("Opt for jewel tones or warm colors that enhance your medium skin tone.")
        else:
            suggestions.append("Avoid overly muted colors that may make your skin appear dull.")
    elif skin_tone == "dark":
        if clothing_color in ["bright colors", "deep tones"]:
            suggestions.append("Bold and bright colors, as well as deep tones, complement your dark skin.")
        else:
            suggestions.append("Avoid overly light colors that may not stand out against your dark skin.")

    # Rule 3: Occasion
    if occasion == "casual":
        suggestions.append("For a casual occasion, consider comfortable and relaxed clothing styles.")
    elif occasion == "formal":
        suggestions.append("Opt for more sophisticated and polished looks for formal occasions.")
    elif occasion == "party":
        suggestions.append("Choose fun and stylish outfits for a party atmosphere.")

    return suggestions
    

    
