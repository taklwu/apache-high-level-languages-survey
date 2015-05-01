@outputSchema("values:bag{t:tuple(key, value)}")
def bag_of_tuples(map_dict):
    return map_dict.items()
