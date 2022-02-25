<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- CSS -->
    <link rel="stylesheet" href=" {{ mix('css/app.css') }}">

    <!-- JS -->
    <script src="{{ mix('js/app.js') }}"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jscroll/2.4.1/jquery.jscroll.min.js"></script>

    <title>RSB - Ao vivo</title>

    @stack('css')
    @yield('css')
</head>

<body>

    <div class="main">

        @yield('content')

    </div>

    @yield('js')
    @stack('js')

</body>

</html>
