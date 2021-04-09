import operator, json

OPERATORS = {'and': operator.and_, 'or': operator.or_}

def polska(srt): # вычисления выражения в обратной польской записи
    stack = []
    lst = list(srt)
    for i in srt:
        if i.isdigit():
            stack.append(i)
            lst.remove(i)
        else:
            cnt1, cnt2 = stack.pop(), stack.pop()
            stack.append(OPERATORS[i](int(cnt2), int(cnt1)))
            lst.remove(i)
    return stack.pop()

def ask_question(qonsequent): # задаем вопрос
    answer = ''
    while not answer in qonsequent["qonsequent"]['answers']:
        answer = input('{} ({}) '.format(qonsequent["qonsequent"]['question'], ','.join(qonsequent["qonsequent"]['answers'])))
    used_fact = {qonsequent["qonsequent"]["fact"] : answer}
    return used_fact


with open('knowledge_base.json', 'r') as file:
    rules = json.load(file)['rules']
    list_used_facts = [{"laptop" : "no"}, {"question" : "?"}] # Создаем список и записываем начальные факты

    for rule in rules:
        list_logical = []
        for item in rules[rule]['defrule']['active_facts']: # проверяем какие факты записаны в правиле
            if item in list_used_facts: # если факт совпал в "active_facts", то добявляем "1" в список list_logical
                list_logical.append('1')
            else: # Если нет, то "0"
                list_logical.append('0')

        for key, value in rules[rule]["logical-operators"].items(): # добавляем логические операторы для образования обратной польской записи
            list_logical.insert(int(key), value)

        logical = polska(list_logical) # результат вычисления обратной польской записи

        if logical: # если logical истинно, значит правило сработало. задаем вопрос
            if rules[rule]['type'] == "concluion": # если дошли до заключения, то выводим ответ и выходим из цикла
                for answer, laptop in rules[rule]["answer"].items():
                    print(answer, ":", laptop)
                break
            active_fact = ask_question(rules[rule]) # записываем активный факт
            list_used_facts.append(active_fact) # добавляем факт в список

