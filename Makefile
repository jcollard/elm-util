CC = elm
SRC = src
TEST = test
EXAMPLES = examples
RESOURCES=resources/
RTS=$(RESOURCES)/elm-runtime.js
BUILD_FLAGS = --make --src-dir=$(SRC)
FLAGS = $(BUILD_FLAGS) --only-js
BUILD_EXAMPLE_FLAGS = $(BUILD_FLAGS) --src-dir=$(EXAMPLES)
TEST_FLAGS = $(FLAGS) --src-dir=$(TEST)
BUILD_TEST_FLAGS = $(BUILD_FLAGS) --src-dir=$(TEST)


compile: sprite animation test_framework resources

test: tests

examples: moveAnimationExample examples_resources

resources: build/$(SRC)/$(RESOURCES)
build/$(SRC)/$(RESOURCES): $(RESOURCES)
	cp $(RESOURCES) build/$(SRC)/ -r

test_resources: build/$(TEST)/$(RESOURCES)
build/$(TEST)/$(RESOURCES): $(RESOURCES)
	cp $(RESOURCES) build/$(TEST)/ -r

examples_resources: build/$(EXAMPLES)/$(RESOURCES)
build/$(EXAMPLES)/$(RESOURCES): $(RESOURCES)
	cp $(RESOURCES) build/$(EXAMPLES) -r

## Graphics.Sprite
Sprite = $(SRC)/Graphics/Sprite
Sprite.js = build/$(Sprite).js
Sprite.elm = $(Sprite).elm

sprite: $(Sprite.js)
$(Sprite.js): $(Sprite.elm)
	$(CC) $(FLAGS) $(Sprite.elm)

## Graphics.Animation

Animation = $(SRC)/Graphics/Animation
Animation.js = build/$(Animation).js
Animation.elm = $(Animation).elm

animation: $(Animation.js)
$(Animation.js): $(Animation.elm)
	$(CC) $(FLAGS) $(Animation.elm)

## Test

Test = $(SRC)/Test
Test.js = build/$(Test).js
Test.elm = $(Test).elm

test_framework: $(Test.js)
$(Test.js): $(Test.elm)
	$(CC) $(FLAGS) $(Test.elm)

## Tests

# Graphics.AnimationTest

AnimationTest = $(TEST)/Graphics/AnimationTest
AnimationTest.js = build/$(AnimationTest).js
AnimationTest.elm = $(AnimationTest).elm
animationTest: $(AnimationTest.js)
$(AnimationTest.js): $(AnimationTest.elm) $(Animation.elm)
	$(CC) $(TEST_FLAGS) $(AnimationTest.elm)


Tests = $(TEST)/Tests
Tests.html = build/$(Tests).html
Tests.elm = $(Tests).elm
tests: $(Tests.html) $(AnimationTest.js) test_resources
$(Tests.html): $(Tests.elm) $(AnimationTest.elm) $(Animation.elm)
	$(CC) --runtime=$(RTS) $(BUILD_TEST_FLAGS) $(Tests.elm)



# Move Animation Example
MoveAnimationExample = $(EXAMPLES)/Graphics/Animation/MoveAnimationExample
MoveAnimationExample.html = build/$(MoveAnimationExample).html
MoveAnimationExample.elm = $(MoveAnimationExample).elm

moveAnimationExample: $(MoveAnimationExample.html)
$(MoveAnimationExample.html): $(MoveAnimationExample.elm) $(Animation.elm)
	$(CC) --runtime=../../$(RTS) $(BUILD_EXAMPLE_FLAGS) $(MoveAnimationExample.elm)



clean:
	rm build/ -rf
	rm cache/ -rf
