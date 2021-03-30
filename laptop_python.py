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
    used_rule = {qonsequent["qonsequent"]["fact"] : answer}
    return used_rule


with open('knowledge_base.json', 'r') as file:
    rules_or_conclusions = json.load(file)['rules_or_conclusion']
    list_used_rule = [{"laptop" : "no"}, {"question" : "?"}] # Создаем список и записываем начальные правила

    for rule in rules_or_conclusions:
        list_logical = []
        for item in rules_or_conclusions[rule]['defrule']['active_rule']: # проверяем использовались ли правила
            if item in list_used_rule: # если да, то добявляем "1" в список list_logical
                list_logical.append('1')
            else: # Если нет, то "0"
                list_logical.append('0')

        for key, value in rules_or_conclusions[rule]["logical-operators"].items(): # добавляем логические операторы. для образования обратной польской записи
            list_logical.insert(int(key), value)

        logical = polska(list_logical) # результат вычисления обратной польской записи

        if logical: # если logical истинно, значит задаем вопрос
            if rules_or_conclusions[rule]['type'] == "concluion": # если дошли до заключения, то выводим ответ и выходим из цикла
                for answer, laptop in rules_or_conclusions[rule]["answer"].items():
                    print(answer, ":", laptop)
                break
            active_rule = ask_question(rules_or_conclusions[rule]) # записываем активное правило
            list_used_rule.append(active_rule) # добавляем правило в список использованных
