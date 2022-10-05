##Python String Operations

text1="this is my first line";
print(text1) 

print("Step 1")
#read first 2 characters
print(text1[:2])

print("Step 2")
#read last 2 characters
print(text1[:-2])

print("Step 3")
#find the lenght for string 
print(len(text1))

print("Step 4")
#print full tex
for i in text1:
    print(i)

print("Step 5")
#print full text
i=0
while i<len(text1):
    print(text1[i])
    i+=1

print("Step 6")
#print index (enumerate as int is not iterable)
for index, letter in enumerate(text1):
    if index%4 is 0:
        print(index,letter)


