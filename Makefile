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


compile: graphics test_framework resources

graphics: sprite animation location path

all: compile test examples

test: tests

examples: animationExamples examples_resources

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

## Graphics.Location

Location = $(SRC)/Graphics/Location
Location.js = build/$(Location).js
Location.elm = $(Location).elm

location: $(Location.js)
$(Location.js): $(Location.elm)
	$(CC) $(FLAGS) $(Location.elm)

## Graphics.Path

Path = $(SRC)/Graphics/Path
Path.js = build/$(Path).js
Path.elm = $(Path).elm

path: $(Path.js)
$(Path.js): $(Path.elm)
	$(CC) $(FLAGS) $(Path.elm)



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

# Graphics.LocationTest

LocationTest = $(TEST)/Graphics/LocationTest
LocationTest.js = build/$(LocationTest).js
LocationTest.elm = $(LocationTest).elm
locationTest: $(LocationTest.js)
$(LocationTest.js): $(LocationTest.elm) $(Location.elm)
	$(CC) $(TEST_FLAGS) $(LocationTest.elm)

# Graphics.PathTest

PathTest = $(TEST)/Graphics/PathTest
PathTest.js = build/$(PathTest).js
PathTest.elm = $(PathTest).elm
pathTest: $(PathTest.js)
$(PathTest.js): $(PathTest.elm) $(Path.elm)
	$(CC) $(TEST_FLAGS) $(PathTest.elm)

Tests = $(TEST)/Tests
Tests.html = build/$(Tests).html
Tests.elm = $(Tests).elm
tests: $(Tests.html) test_resources
$(Tests.html): $(Tests.elm) $(AnimationTest.elm) $(Animation.elm) $(LocationTest.elm) $(Location.elm) $(Animation.elm) $(PathTest.elm) $(Path.elm)
	$(CC) --runtime=$(RTS) $(BUILD_TEST_FLAGS) $(Tests.elm)


animationExamples: easeAnimationExample moveAnimationExample composedAnimationExample

# Move Animation Example
MoveAnimationExample = $(EXAMPLES)/Graphics/Animation/MoveAnimationExample
MoveAnimationExample.html = build/$(MoveAnimationExample).html
MoveAnimationExample.elm = $(MoveAnimationExample).elm

moveAnimationExample: $(MoveAnimationExample.html)
$(MoveAnimationExample.html): $(MoveAnimationExample.elm) $(Animation.elm)
	$(CC) --runtime=../../$(RTS) $(BUILD_EXAMPLE_FLAGS) $(MoveAnimationExample.elm)

# Ease Animation Example
EaseAnimationExample = $(EXAMPLES)/Graphics/Animation/EaseAnimationExample
EaseAnimationExample.html = build/$(EaseAnimationExample).html
EaseAnimationExample.elm = $(EaseAnimationExample).elm

easeAnimationExample: $(EaseAnimationExample.html)
$(EaseAnimationExample.html): $(EaseAnimationExample.elm) $(Animation.elm)
	$(CC) --runtime=../../$(RTS) $(BUILD_EXAMPLE_FLAGS) $(EaseAnimationExample.elm)


# Composed Animation Example
ComposedAnimationExample = $(EXAMPLES)/Graphics/Animation/ComposedAnimationExample
ComposedAnimationExample.html = build/$(ComposedAnimationExample).html
ComposedAnimationExample.elm = $(ComposedAnimationExample).elm

composedAnimationExample: $(ComposedAnimationExample.html)
$(ComposedAnimationExample.html): $(ComposedAnimationExample.elm) $(Animation.elm)
	$(CC) --runtime=../../$(RTS) $(BUILD_EXAMPLE_FLAGS) $(ComposedAnimationExample.elm)



clean:
	find . -name "*.elmi" -delete
	find . -name "*.elmo" -delete
	rm build/ -rf
	rm cache/ -rf
