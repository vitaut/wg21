## std::remove\_cvref

### Summary

<table>
<colgroup>
<col style="width: 60%" />
<col style="width: 40%" />
</colgroup>
<tbody>
<tr class="odd">
<td><div align="center"><strong>Before C++20</strong></div></td>
<td><div align="center"><strong>After C++20</strong></div></td>
</tr>
<tr class="even">
<td>

<pre lang="cpp">
typename std::remove_cv&lt;
    typename std::remove_reference&lt;T&gt;::type&gt;::type

std::remove_cv_t&lt;std::remove_reference_t&lt;T&gt;&gt;
</pre></td>
<td>

<pre lang="cpp">
typename std::remove_cvref&lt;T&gt;::type

std::remove_cvref_t&lt;T&gt;
</pre></td>
</tr>
</tbody>
</table>

### Detail

`std::decay<T>` is often (mis)used to obtain the type name for a type
that is potentially a reference, cv-qualified, or both:

``` cpp
template <typename T>
auto f(T&& t) {
    // Removes reference and cv-qualifiers...
    using type_name = std::decay_t<T>;

    // To avoid this problem...
    static_assert(!std::is_same_v<int&, int>);
    static_assert(!std::is_same_v<int const, int>);

    // When evaluating the following conditional expression.
    if constexpr (std::is_same_v<type_name, int>) {
        use_int(t);
    }

    // Similarly, a reference type is not an array...
    else if constexpr (std::is_array_v<type_name>) {
        use_array(t);
    }

    // Nor is it a function.
    else if constexpr (std::is_function_v<type_name>) {
        use_function(t);
    }

    else {
        use_other(t);
    }
}

int main() {
    auto const i = 42;
    auto const s = std::string();

    f(i); // T == 'int const&', type_name == 'int'; invokes 'use_int'.
    f(s); // T == 'std::string const&', type_name == 'std::string'; invokes 'use_other'.
}
```

However, `std::decay<T>` introduces decay semantics for array and
function types:

``` cpp
int arr[3];

// T == 'int (&)[3]', but type_name == 'int*' due to array-to-pointer decay.
// 'std::is_array_v<int*>' is false; invokes 'use_other'.
f(arr);

void g();

// T == 'void (&)()', but type_name == 'void (*)()' due to function-to-pointer decay.
// 'std::is_function<void (*)()>' is false; invokes 'use_other'.
f(g);
```

In C++20, the standard library provides the `std::remove_cvref<T>` type
trait to fulfill this purpose without introducing unwanted decay
semantics:

``` cpp
template <typename T>
auto f(T&& t) {
    using type_name = std::remove_cvref_t<T>;

    ...
}

int main() {
    auto const i = 42;
    int arr[3];
    void g();


    f(0); // Same as before.
    f(i); // Same as before.

    f(arr); // T == 'int (&)[3]', type_name == 'int [3]'; invokes 'use_array'.
    f(g); // T == 'void (&)()', type_name == 'void()'; invokes 'use_function'.
}
```
