# Generate PDF from HTML Using Headless Google Chrome

Generate PDFs without needing to mount local directories.

```
docker build -t chrome-print-pdf .
```

Create a PDF from a URL or an HTML file. Note that when running the container we do not specify the `-t` flag. 

PDF from HTML file:
```
cat file.html | docker run --rm -i chrome-print-pdf > file.pdf
```

PDF from URL:
```
docker run --rm -i chrome-print-pdf http://www.roswellpark.org/ > file.pdf
```

PHP:
```php
$pipes = [];
$command = 'docker run --rm -i chrome-print-pdf';
$descriptor_spec = [
    0 => [ 'pipe', 'r' ],
    1 => [ 'pipe', 'w' ],
    2 => [ 'pipe', 'w' ],
];
$process = proc_open($command, $descriptor_spec, $pipes);
fwrite($pipes[0], file_get_contents('file.html'));
fclose($pipes[0]);

$output = stream_get_contents($pipes[1]);
$stderr = stream_get_contents($pipes[2]);
fclose($pipes[1]);
fclose($pipes[2]);
$return_value = proc_close($process);
file_put_contents('file.pdf', $output);
print 'Docker output:' . PHP_EOL . $stderr;
```

# Credits

Work based on:
- [femtopixel/docker-google-chrome-headless](https://github.com/femtopixel/docker-google-chrome-headless)
- [Chromium command line switches](https://peter.sh/experiments/chromium-command-line-switches/)
- [Ben Plessinger's awesome work on XDMoD](https://github.com/ubccr/xdmod/blob/xdmod9.5/libraries/charting.php)

