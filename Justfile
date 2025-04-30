assets := 'assets'
fonts := assets / 'fonts'

source := 'src'
output := 'out'

main := source / 'main.typ'
pdf := output / 'din5008-letter.pdf'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := fonts

# list recipes
[private]
default:
	@just --list --unsorted

# initialize the repo for editing
init:
	cp {{ assets / 'self-template.toml' }} {{ assets / 'self.toml' }}

# generate document with sensitive data
build name street number zip city: prep
	typst compile \
		--input 'name={{ name }}' \
		--input 'street={{ street }}' \
		--input 'number={{ number }}' \
		--input 'zip={{ zip }}' \
		--input 'city={{ city }}' \
		{{ main }} {{ pdf }}

# watch document with sensitive data
watch name street number zip city: prep
	typst watch \
		--input 'name={{ name }}' \
		--input 'street={{ street }}' \
		--input 'number={{ number }}' \
		--input 'zip={{ zip }}' \
		--input 'city={{ city }}' \
		{{ main }} {{ pdf }}

# clean all output directories
clean:
	rm --recursive --force {{ output }}

# run the ci checks locally
ci: prep
	typst compile \
		--input 'self=self-template' \
		--input 'name=Max Mustermann' \
		--input 'street=Musterstraße' \
		--input 'number=1' \
		--input 'zip=11111' \
		--input 'city=Musterstadt' \
		{{ main }} {{ pdf }}

[private]
prep:
	rm --recursive --force {{ output }}
	mkdir {{ output }}
