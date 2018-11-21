## *explicit(boolean-expression)*

<table>
<tbody>
<tr class="odd">
<td><div align="center"><strong>C++17</strong></div></td>
<td><div align="center"><strong>C++20</strong></div></td>
</tr>
<tr class="even">
<td>

<pre lang="cpp">
struct MyInt
{
    int val = 0;

    // explicit if the int type coming in
    // is bigger than what we can hold.
    // eg explicit if you pass a long,
    //    implicit if you pass a short
    // TODO: handle unsigned...
    template &lt;typename Init,
        std::enable_if_t&lt;
            (sizeof(Init) &gt; sizeof(int)),
            int&gt; = 0&gt;
    explicit MyInt(Init init)
        : val(static_cast&lt;int&gt;(init))
    {
    }

    template &lt;typename Init,
        std::enable_if_t&lt;
            (sizeof(Init) &lt;= sizeof(int)),
            int&gt; = 0&gt;
    MyInt(Init init)
        : val(static_cast&lt;int&gt;(init))
    {
    }
};
</pre></td>
<td>

<pre lang="cpp">
struct MyInt
{
    int val = 0;

    // explicit if the int type coming in
    // is bigger than what we can hold.
    // eg explicit if you pass a long,
    //    implicit if you pass a short
    // (TODO: check for unsigned...)
    template &lt;typename Init&gt;
    explicit(sizeof(Init) &gt; sizeof(int))
    MyInt(Init init)
        : val(static_cast&lt;int&gt;(init))
    {
    }
};
</pre></td>
</tr>
</tbody>
</table>

That can be useful on its own. But an interesting corollary is
“explicit(false)”. What’s the point of that over the “equivalent” of
just not saying explicit at all? It is being explicit about an implicit
constructor. For example:

<table>
<colgroup>
<col style="width: 23%" />
<col style="width: 40%" />
<col style="width: 37%" />
</colgroup>
<tbody>
<tr class="odd">
<td><div align="center"><strong>Questionable C++</strong></div></td>
<td><div align="center"><strong>Better C++</strong></div></td>
<td><div align="center"><strong>C++20</strong></div></td>
</tr>
<tr class="even">
<td>

<pre lang="cpp">
struct Foo
{
    Foo(Bar b);
};
</pre></td>
<td>

<pre lang="cpp">
struct Foo
{
    /* yes, implicit*/ Foo(Bar b);
};
</pre></td>
<td>

<pre lang="cpp">
struct Foo
{
    explicit(false) Foo(Bar b);
};
</pre></td>
</tr>
</tbody>
</table>

In code review of the first example, I would probably ask if the
constructor should be explicit - the general rule is that most
constructors should be explicit (it is another default that C++ got
wrong). (because implicit conversions often lead to mistaken
conversions, which leads to bugs) So some people leave comments, to make
it clear. But comments that just explain syntax (and not *why*) are
better done as more clear code.

Using `explicit(false)` shows that the implicitness wasn’t an accidental
omission, but a real design decision. (You might still want to leave a
comment as to *why* that is the right design decision.)

P.S. Please don’t `#define implicit explicit(false)`. *Just Don’t*. Do
Not. Not Do. Don’t even Try.

See also [wg21.link/p0892](https://wg21.link/p0892)
