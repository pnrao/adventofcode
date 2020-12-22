from copy import copy

def parseblk(b):
    return [int(l) for l in b.strip().split('\n')[1:]]

def readinput(fln):
    with open(fln) as f:
        blk = f.read().split("\n\n")
        return parseblk(blk[0]), parseblk(blk[1])

def part1(deck1, deck2):
    while len(deck1)*len(deck2) > 0:
        p1 = deck1.pop(0)
        p2 = deck2.pop(0)
        if p1 > p2:
            deck1.extend([p1, p2])
        else:
            deck2.extend([p2, p1])

def score(deck1, deck2):
    cat = deck1+deck2
    cat.reverse()
    s = sum([i*v for (i,v) in enumerate(cat,start=1)])
    return s

def recursivecombat(deck1, deck2):
    winner = 0
    oldrounds=set()
    while len(deck1)*len(deck2) > 0:
        if tuple((tuple(deck1),tuple(deck2))) in oldrounds:
            return 1
        else:
            oldrounds.add(tuple((tuple(deck1),tuple(deck2))))
            p1 = deck1.pop(0)
            p2 = deck2.pop(0)
            if len(deck1) >= p1 and len(deck2) >= p2:
                winner = recursivecombat(copy(deck1[:p1]),copy(deck2[:p2]))
            elif p1 > p2:
                winner = 1
            else:
                winner = 2

            if winner == 1:
                deck1.extend([p1, p2])
                if len(deck2) == 0: return 1
            else:
                deck2.extend([p2, p1])
                if len(deck1) == 0: return 2

if __name__ == '__main__':
    d1,d2 = readinput("input22.txt")
    part1(d1, d2)
    print("Part 1: ", score(d1, d2))
    d1,d2 = readinput("input22.txt")
    recursivecombat(d1, d2)
    print("Part 2: ", score(d1, d2))
